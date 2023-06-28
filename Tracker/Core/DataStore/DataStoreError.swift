import Foundation

enum DataStoreError: Error {
    case failedToLoadPersistentContainer(Error)
}
