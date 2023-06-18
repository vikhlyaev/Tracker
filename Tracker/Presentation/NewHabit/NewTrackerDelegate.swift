import UIKit

protocol NewTrackerDelegate: AnyObject {
    func didUpdateCategory(_ updatedCategory: TrackerCategory)
}
