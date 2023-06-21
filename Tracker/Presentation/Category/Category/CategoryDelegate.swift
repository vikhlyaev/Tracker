import Foundation

protocol CategoryDelegate: AnyObject {
    func didSelectCategory(_ selectedCategory: TrackerCategory)
}
