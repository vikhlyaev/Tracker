import Foundation
import UIKit
import CoreData

final class CategoryStoreImpl: NSObject {
    private let dataStore: DataStore
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private weak var delegate: StoreDelegate?
    
    private lazy var fetchedResultController: NSFetchedResultsController<CategoryManagedObject> = {
        let request = CategoryManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
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

    // MARK: - Init
    
    init(dataStore: DataStore, delegate: StoreDelegate) {
        self.dataStore = dataStore
        self.context = dataStore.managedObjectContext
        self.delegate = delegate
    }
    
    convenience init(delegate: StoreDelegate) {
        self.init(dataStore: DataStore.shared, delegate: delegate)
    }
    
    private func convert(managedObject: CategoryManagedObject) -> Category? {
        guard
            let id = managedObject.id,
            let name = managedObject.name,
            let trackerManagedObjects = managedObject.trackers?.array as? [TrackerManagedObject]
        else { return nil }
        let trackers: [Tracker] = trackerManagedObjects
            .compactMap({ trackerManagedObject in
                guard
                    let id = trackerManagedObject.id,
                    let name = trackerManagedObject.name,
                    let colorHex = trackerManagedObject.hexColor,
                    let emoji = trackerManagedObject.emoji,
                    let schedule = trackerManagedObject.schedule?.compactMap({ WeekDay(rawValue: $0) })
                else { return nil }
                return Tracker(
                    id: id,
                    name: name,
                    color: ColorMarshall.shared.decode(hexColor: colorHex),
                    emoji: emoji,
                    schedule: schedule
                )
            })
        return Category(
            id: id,
            name: name,
            trackers: trackers
        )
    }
    
    private func convert(managedObject: TrackerManagedObject) -> Tracker? {
        guard
            let id = managedObject.id,
            let name = managedObject.name,
            let emoji = managedObject.emoji,
            let hexColor = managedObject.hexColor,
            let schedule = managedObject.schedule?.compactMap({ WeekDay(rawValue: $0) })
        else { return nil }
        return Tracker(
            id: id,
            name: name,
            color: ColorMarshall.shared.decode(hexColor: hexColor),
            emoji: emoji,
            schedule: schedule
        )
    }
}

// MARK: - StoreProtocol

extension CategoryStoreImpl: CategoryStore {
    var isEmpty: Bool {
        guard let count = fetchedResultController.fetchedObjects?.count else { return true }
        return count == 0
    }
    
    var numberOfSections: Int {
        fetchedResultController.fetchedObjects?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard
            let categoryManagedObjects = fetchedResultController.fetchedObjects,
            let trackers = categoryManagedObjects[section].trackers?.array as? [TrackerManagedObject]
        else { return 0 }
        return trackers.count
    }
    
    func object(at index: Int) -> Category? {
        guard
            let categoryManagedObject = fetchedResultController.fetchedObjects?[index] as? CategoryManagedObject
        else { return nil }
        return convert(managedObject: categoryManagedObject)
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker? {
        guard
            let trackerManagedObject = fetchedResultController.fetchedObjects?[indexPath.section].trackers?.array[indexPath.item] as? TrackerManagedObject
        else { return nil }
        return convert(managedObject: trackerManagedObject)
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
    
    func filter(by date: Date, and searchText: String? = nil) {
        fetchedResultController.fetchRequest.predicate = NSPredicate()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension CategoryStoreImpl: NSFetchedResultsControllerDelegate {
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
