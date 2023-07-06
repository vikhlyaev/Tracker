import UIKit
import YandexMobileMetrica

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var displayOnboarding: Bool {
        get {
            UserDefaults.standard.bool(forKey: "displayOnboarding")
        } set {
            UserDefaults.standard.set(newValue, forKey: "displayOnboarding")
        }
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        if !displayOnboarding {
            displayOnboarding = true
            window?.rootViewController = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: nil
            )
        } else {
            window?.rootViewController = AppTabBarController()
        }
        window?.makeKeyAndVisible()
        
        guard
            let configuration = YMMYandexMetricaConfiguration(
                apiKey: "1c664000-d98d-401a-9ef1-1b0e03208aac"
            )
        else { return true }
        YMMYandexMetrica.activate(with: configuration)
        
        return true
    }
    
}

// API Yandex
// 1c664000-d98d-401a-9ef1-1b0e03208aac

