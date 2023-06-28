import Foundation
import CoreData

extension NSPersistentContainer {
    static func create(for model: String) throws -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        var loadError: Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }
        return container
    }
}

