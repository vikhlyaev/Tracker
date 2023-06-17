import Foundation

protocol NewCategoryDelegate: AnyObject {
    func didCreateNewCategory(with name: String)
}
