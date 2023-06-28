import Foundation

final class WeekDayMarshall {
    
    static let shared = WeekDayMarshall()
    
    private init() {}
    
    func encode(days: [WeekDay]) -> String {
        days
            .map({ "\($0.rawValue)" })
            .joined(separator: ", ")
    }
    
    func decode(days: String) -> [WeekDay] {
        days
            .components(separatedBy: ", ")
            .compactMap({ Int($0) })
            .compactMap({ WeekDay(rawValue: $0) })
    }
}
