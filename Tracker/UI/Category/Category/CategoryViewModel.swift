import Foundation

protocol CategoryViewModelProtocol: AnyObject {
    var selectedCategory: Category? { get }
    init(categoryStore: CategoryStore)
}

final class CategoryViewModel: CategoryViewModelProtocol {
    private let categoryStore: CategoryStore
    
    var selectedCategory: Category?
    
    init(categoryStore: CategoryStore) {
        self.categoryStore = categoryStore
    }
}
