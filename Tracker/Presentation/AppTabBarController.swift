import UIKit

final class AppTabBarController: UITabBarController {
    
    private enum Tabs: Int {
        case trackers
        case statistic
        
        var title: String {
            switch self {
            case .trackers:
                return "Трекеры"
            case .statistic:
                return "Статистика"
            }
        }
        
        var iconName: String {
            switch self {
            case .trackers:
                return "record.circle.fill"
            case .statistic:
                return "hare.fill"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabItems()
    }
    
    private func setupTabBar() {
        tabBar.layer.borderColor = UIColor.appGray.cgColor
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.masksToBounds = true
    }
    
    private func setupTabItems() {
        let dataSource: [Tabs] = [
            .trackers,
            .statistic
        ]
        
        viewControllers = dataSource.map {
            switch $0 {
            case .trackers:
                return wrapInNavigationController(TrackersViewController())
            case .statistic:
                return wrapInNavigationController(StatisticViewController())
            }
        }
        
        viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            $1.tabBarItem.tag = $0
        }
    }
    
    private func wrapInNavigationController(_ vc: UIViewController) -> UINavigationController {
        UINavigationController(rootViewController: vc)
    }
}
