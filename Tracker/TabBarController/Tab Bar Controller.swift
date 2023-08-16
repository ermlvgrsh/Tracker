import UIKit


final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupVC()
    }
    
    fileprivate func createNavController(for
                                         rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
    
    func setupVC() {
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.borderColor = DarkMode().tintAddButtonColor.cgColor
        guard let trackerImage = UIImage(named: "record.circle.fill"),
              let statisticImage = UIImage(named: "hare.fill") else { fatalError() }
        let trackerService = TrackerService.shared
        viewControllers = [
            createNavController(for: TrackersViewController(trackerService: trackerService), title: "trackers".localized, image: trackerImage),
            createNavController(for: StatisticViewController(), title: "statistic".localized, image: statisticImage)
        ]
    }
    
}

