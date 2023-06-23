import Foundation

protocol StoreProtocol {
    associatedtype Object
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> Object?
}
