import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private lazy var navigationController = UINavigationController(nibName: nil, bundle: nil)
    private lazy var postsCoordinator = PostsCoordinatorDefault()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        postsCoordinator.start(from: navigationController) { /* do nothing */ }

        return true
    }
}
