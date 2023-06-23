import Foundation

final class WeekDayTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        if let weekDayArray = value as? [WeekDay] {
            let intArray = weekDayArray.map { $0.rawValue }
            return NSArray(array: intArray)
        }
        return nil
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        if let nsArray = value as? NSArray {
            let intArray = nsArray.compactMap { $0 as? Int }
            let weekDayArray = intArray.compactMap { WeekDay(rawValue: $0) }
            return weekDayArray
        }
        return nil
    }
}

extension NSValueTransformerName {
    static let classNameTransformerName = NSValueTransformerName(rawValue: "WeekDayTransformer")
}

