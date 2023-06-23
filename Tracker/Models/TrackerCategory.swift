import Foundation

struct TrackerCategory: Equatable {
    let id: UUID
    let name: String
    let trackers: [Tracker]
}
