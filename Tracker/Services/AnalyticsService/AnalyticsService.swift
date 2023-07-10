import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API Key") as? String
    
    private init() {}
    
    func activate() throws {
        guard
            let apiKey,
            let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey)
        else { throw AnalyticsServiceError.invalidApiKey }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: Event, screen: Screen, item: Item? = nil) {
        var params: [AnyHashable: Any] = ["screen": screen.rawValue]
        if event == .click, let item {
            params["item"] = item.rawValue
        }
        
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params) { error in
            print("REPORT ERROR: \(error.localizedDescription)")
        }
    }
}

enum Event: String {
    case open
    case close
    case click
}

enum Screen: String {
    case trackers
}

enum Item: String {
    case addTracker = "add_tracker"
    case track
    case filter
    case edit
    case delete
}
