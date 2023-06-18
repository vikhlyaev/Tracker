import Foundation

struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
}

// MARK: - Equatable

extension TrackerCategory: Equatable {
    static func == (lhs: TrackerCategory, rhs: TrackerCategory) -> Bool {
        lhs.name == rhs.name && lhs.trackers == rhs.trackers
    }
}
