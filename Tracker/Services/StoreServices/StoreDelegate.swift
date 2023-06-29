import Foundation

protocol StoreDelegate: AnyObject {
    func didUpdate(_ update: StoreUpdate)
}
