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
    
}
