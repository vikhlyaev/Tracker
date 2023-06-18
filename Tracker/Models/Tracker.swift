import UIKit

struct Tracker: Equatable {
    let id: UUID = UUID()
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
}
