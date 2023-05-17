import UIKit


final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let trackersViewController = setupTrackersViewController()
        let statisticViewController = setupStatisticViewController()
        self.viewControllers = [trackersViewController, statisticViewController]

    }
    
    private func setupTrackersViewController() -> TrackersViewController {
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "record.circle.fill"), tag: 0)
        return trackersViewController
    }
    
    private func setupStatisticViewController() -> StatisticViewController {
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "hare.fill"), tag: 1)
        return statisticViewController
    }
}
