import Foundation
import CoreData

final class TrackerStore: NSObject {
    
    private let dataStore: DataStore
    private let context: NSManagedObjectContext
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
        self.context = dataStore.managedObjectContext
        super.init()
    }
    
    override convenience init() {
        self.init(dataStore: DataStore.shared)
    }
    
    private func convert(tracker: Tracker) -> TrackerManagedObject {
        let trackerManagedObject = TrackerManagedObject(context: context)
        trackerManagedObject.id = tracker.id
        trackerManagedObject.name = tracker.name
        trackerManagedObject.emoji = tracker.emoji
        trackerManagedObject.hexColor = ColorMarshall.shared.encode(color: tracker.color)
        trackerManagedObject.schedule = tracker.schedule.map { $0.rawValue }
        return trackerManagedObject
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
                trackerManagedObject.category = categoryManagedObject
                categoryManagedObject.addToTrackers(trackerManagedObject)
                try context.save()
            }
        }
    }
}
