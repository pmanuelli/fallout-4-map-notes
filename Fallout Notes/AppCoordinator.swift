import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    private lazy var mapCoordinator = MapCoordinator(navigationController: navigationController)
    
    init(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.overrideUserInterfaceStyle = .dark
        window.makeKeyAndVisible()
    }
    
    func start() {

        mapCoordinator.start()
        
        let fakeLaunchScreen = FakeLaunchScreenViewController(duration: 1)
        fakeLaunchScreen.modalTransitionStyle = .crossDissolve
        fakeLaunchScreen.modalPresentationStyle = .overFullScreen
        
        navigationController.present(fakeLaunchScreen, animated: false)

        perform(after: 1) {
            self.navigationController.dismiss(animated: true)
        }
    }
}
