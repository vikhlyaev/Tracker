import Foundation
import CoreData

protocol CoreDataService {
    func createTrackerFetchedResultsController() -> NSFetchedResultsController<TrackerManagedObject>
    func createTrackerCategoryFetchedResultsController() -> NSFetchedResultsController<TrackerCategoryManagedObject>
    func createTrackerRecordFetchedResultsController() -> NSFetchedResultsController<TrackerRecordManagedObject>
}
