import Foundation

protocol CategoryStore {
    var isEmpty: Bool { get }
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func add(_ category: Category)
    func object(at index: Int) -> Category?
    func tracker(at indexPath: IndexPath) -> Tracker?
}
