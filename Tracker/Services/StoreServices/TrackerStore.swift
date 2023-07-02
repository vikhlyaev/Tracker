import Foundation
import CoreData

final class TrackerStore: NSObject {
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private let dataStore: DataStore
    private let context: NSManagedObjectContext
    private weak var delegate: StoreDelegate?
    
    private lazy var fetchedResultController: NSFetchedResultsController<TrackerManagedObject> = {
        let request = TrackerManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "category.name", ascending: true)]
        let fetchedResultController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "category.name",
            cacheName: nil
        )
        fetchedResultController.delegate = self
        try? fetchedResultController.performFetch()
        return fetchedResultController
    }()
    
    init(dataStore: DataStore, delegate: StoreDelegate?) {
        self.dataStore = dataStore
        self.context = dataStore.managedObjectContext
        self.delegate = delegate
        super.init()
    }
    
    convenience init(delegate: StoreDelegate? = nil) {
        self.init(dataStore: DataStore.shared, delegate: delegate)
    }
    
    private func convert(weekDay: WeekDay) -> WeekDayManagedObject {
        let weekDayManagedObject = WeekDayManagedObject(context: context)
        weekDayManagedObject.index = Int16(weekDay.numberValue)
        return weekDayManagedObject
    }
    
    private func convert(managedObject: WeekDayManagedObject) -> WeekDay? {
        let index = Int(managedObject.index)
        switch index {
        case 1: return WeekDay.sunday
        case 2: return WeekDay.monday
        case 3: return WeekDay.tuesday
        case 4: return WeekDay.wednesday
        case 5: return WeekDay.thursday
        case 6: return WeekDay.friday
        case 7: return WeekDay.saturday
        default: return nil
        }
    }
    
    private func convert(tracker: Tracker) -> TrackerManagedObject {
        let trackerManagedObject = TrackerManagedObject(context: context)
        trackerManagedObject.id = tracker.id
        trackerManagedObject.name = tracker.name
        trackerManagedObject.emoji = tracker.emoji
        trackerManagedObject.hexColor = ColorMarshall.shared.encode(color: tracker.color)
        tracker.schedule.forEach { trackerManagedObject.addToSchedule(convert(weekDay: $0)) }
        return trackerManagedObject
    }
    
    private func convert(managedObject: TrackerManagedObject) -> Tracker? {
        guard
            let id = managedObject.id,
            let name = managedObject.name,
            let emoji = managedObject.emoji,
            let hexColor = managedObject.hexColor,
            let scheduleManagedObjects = managedObject.schedule?.array as? [WeekDayManagedObject]
        else { return nil }
        return Tracker(
            id: id,
            name: name,
            color: ColorMarshall.shared.decode(hexColor: hexColor),
            emoji: emoji,
            schedule: scheduleManagedObjects.compactMap { convert(managedObject: $0) }
        )
    }
}

extension TrackerStore {
    var isEmpty: Bool {
        fetchedResultController.sections?.isEmpty ?? true
    }
    
    var numberOfSections: Int {
        fetchedResultController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func add(_ tracker: Tracker, to category: Category) {
        try? dataStore.performSync { context in
            Result {
                let request = CategoryManagedObject.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)
                guard
                    let categoryManagedObject = try? context.fetch(request).first
                else { return }
                let trackerManagedObject = convert(tracker: tracker)
                categoryManagedObject.addToTrackers(trackerManagedObject)
                try context.save()
            }
        }
    }
    
    func object(at indexPath: IndexPath) -> Tracker? {
        let trackerManagedObject = fetchedResultController.object(at: indexPath)
        return convert(managedObject: trackerManagedObject)
    }
    
    func header(at indexPath: IndexPath) -> String? {
        fetchedResultController.sections?[indexPath.section].name
    }
    
    func filter(by weekDayNumber: Int, and searchText: String? = nil) {
        let weekDayPredicate = NSPredicate(format: "ANY schedule == %i", weekDayNumber - 1)
        fetchedResultController.fetchRequest.predicate = weekDayPredicate
        guard let searchText else {
            try? fetchedResultController.performFetch()
            return
        }
        let namePredicate = NSPredicate(format: "%K CONTAINS[c] %@", "name", searchText)
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [namePredicate, weekDayPredicate])
        fetchedResultController.fetchRequest.predicate = compoundPredicate
        try? fetchedResultController.performFetch()
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            StoreUpdate(
                insertedIndexes: insertedIndexes,
                deletedIndexes: nil
            )
        )
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
