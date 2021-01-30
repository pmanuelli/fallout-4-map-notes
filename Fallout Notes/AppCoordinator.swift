import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    private lazy var mapCoordinator = MapCoordinator(navigationController: navigationController)
    
    init(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        mapCoordinator.start()
    }
}
