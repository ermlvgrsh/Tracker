import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        YandexMetricaService.shared.activate()
        if UserDefaults.standard.bool(forKey: "alreadyShown") {
     
            let trackers = TabBarController()
            self.window?.rootViewController = trackers
            window?.makeKeyAndVisible()
            window?.windowScene = scene
        } else {
            let onboarding = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            self.window?.rootViewController = onboarding
            window?.makeKeyAndVisible()
            window?.windowScene = scene
            UserDefaults.standard.set(true, forKey: "alreadyShown")
        }
        
       
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {

        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

