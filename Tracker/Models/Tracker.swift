import UIKit

struct Tracker {
    let id: UUID = UUID()
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
}

typealias Trackers = [Tracker]
