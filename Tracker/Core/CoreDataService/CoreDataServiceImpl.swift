import Foundation
import CoreData

final class CoreDataServiceImpl {
    
    private lazy var persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores { _, error in
            if error != nil {
                assertionFailure("Failed to create a persistant container")
            }
        }
        return container
    }()
    
    private lazy var viewContext: NSManagedObjectContext = {
        persistantContainer.viewContext
    }()
    
    init() {
        ValueTransformer.setValueTransformer(
            WeekDayTransformer(), forName: .classNameTransformerName
        )
    }
    
    private func save(block: (NSManagedObjectContext) throws -> Void) {
        let backgroundContext = persistantContainer.newBackgroundContext()
        backgroundContext.performAndWait {
            do {
                try block(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                }
            } catch {
                assertionFailure("Data not updated")
            }
        }
    }
}

// MARK: - CoreDataService

extension CoreDataServiceImpl: CoreDataService {
    
    func createTrackerFetchedResultsController() -> NSFetchedResultsController<TrackerManagedObject> {
        let request = TrackerManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    func createTrackerCategoryFetchedResultsController() -> NSFetchedResultsController<TrackerCategoryManagedObject> {
        let request = TrackerCategoryManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
    
    func createTrackerRecordFetchedResultsController() -> NSFetchedResultsController<TrackerRecordManagedObject> {
        let request = TrackerRecordManagedObject.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "executionDate", ascending: true)]
        return NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
}
