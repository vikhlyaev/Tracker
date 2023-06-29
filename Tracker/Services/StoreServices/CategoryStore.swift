import Foundation
import UIKit
import CoreData

final class CategoryStore: NSObject {

    private let dataStore: DataStore
    private let context: NSManagedObjectContext
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    
    private weak var delegate: StoreDelegate?
    
    private lazy var fetchedResultController: NSFetchedResultsController<CategoryManagedObject> = {
        let request = CategoryManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    init(dataStore: DataStore, delegate: StoreDelegate) {
        self.dataStore = dataStore
        self.context = dataStore.managedObjectContext
        self.delegate = delegate
    }
}

// MARK: - StoreProtocol

extension CategoryStore: StoreProtocol {
    var isEmpty: Bool {
        guard let count = fetchedResultController.fetchedObjects?.count else { return true }
        return count == 0
    }
    
    var numberOfSections: Int {
        fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Category? {
        let categoryManagedObject = fetchedResultController.object(at: indexPath)
        guard
            let id = categoryManagedObject.id,
            let name = categoryManagedObject.name,
            let trackerManagedObjects = categoryManagedObject.trackers?.array as? [TrackerManagedObject]
        else { return nil }
        let trackers: [Tracker] = trackerManagedObjects
            .compactMap({ trackerManagedObject in
                guard
                    let id = trackerManagedObject.id,
                    let name = trackerManagedObject.name,
                    let colorHex = trackerManagedObject.colorHex,
                    let emoji = trackerManagedObject.emoji,
                    let scheduleString = trackerManagedObject.schedule
                else { return nil }
                return Tracker(
                    id: id,
                    name: name,
                    color: ColorMarshall.shared.decode(hexColor: colorHex),
                    emoji: emoji,
                    schedule: WeekDayMarshall.shared.decode(days: scheduleString)
                )
            })
        return Category(
            id: id,
            name: name,
            trackers: trackers
        )
    }
    
    func add(_ category: Category) {
        try? dataStore.performSync { context in
            Result {
                let categoryManagedObject = CategoryManagedObject(context: context)
                categoryManagedObject.id = category.id
                categoryManagedObject.name = category.name
                categoryManagedObject.createdAt = Date()
                categoryManagedObject.trackers = NSOrderedSet()
                try context.save()
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension CategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            StoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
