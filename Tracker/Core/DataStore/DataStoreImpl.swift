import Foundation
import CoreData

final class DataStoreImpl {
    private let model = "TrackerDataModel"
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    init() throws {
        do {
            container = try NSPersistentContainer.create(for: model)
            context = container.newBackgroundContext()
        } catch let error {
            throw DataStoreError.failedToLoadPersistentContainer(error)
        }
    }
}

// MARK: - DataStore

extension DataStoreImpl: DataStore {
    var managedObjectContext: NSManagedObjectContext {
        context
    }
    
    func fetchCategories() throws -> [CategoryManagedObject] {
        let request = CategoryManagedObject.fetchRequest()
        return try context.fetch(request)
    }
    
    func fetchTrackers(for categoryId: UUID) throws -> [TrackerManagedObject]? {
        let request = CategoryManagedObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", categoryId as CVarArg)
        guard
            let categoryManagedObject = try context.fetch(request).first,
            let trackerManagedObjects = categoryManagedObject.trackers?.array as? [TrackerManagedObject]
        else { return nil }
        return trackerManagedObjects
    }
    
    func fetchRecords(for trackerId: UUID) throws -> [RecordManagedObject]? {
        let request = TrackerManagedObject.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        guard
            let trackerManagedObject = try context.fetch(request).first,
            let recordManagedObjects = trackerManagedObject.records?.array as? [RecordManagedObject]
        else { return nil }
        return recordManagedObjects
    }
    
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
}
