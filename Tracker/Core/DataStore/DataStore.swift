import Foundation
import CoreData

protocol DataStore {
    var managedObjectContext: NSManagedObjectContext { get }
    func fetchTrackers(for categoryId: UUID) throws -> [TrackerManagedObject]?
    func fetchRecords(for trackerId: UUID) throws -> [RecordManagedObject]?
    func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R
}
