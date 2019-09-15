import UIKit

final class PostsListCoordinatorDefault {
    private let selectedPostRepo = SelectedPostRepoDefault()
    private lazy var postsListViewController = PostsListBuilder
        .makeViewController(selectedPostRepo: self.selectedPostRepo, coordinator: self)

    private weak var navigationController: UINavigationController?
    private var completionHandler: (() -> Void)?

    func start(
        from navigationController: UINavigationController,
        completionHandler: @escaping () -> Void
    ) {
        self.navigationController = navigationController
        self.completionHandler = completionHandler

        self.navigationController?.viewControllers = [postsListViewController]
    }
}

extension PostsListCoordinatorDefault: PostsListCoordinator {
    func proceedToPostDetails() {
        let postDetailsViewController = UIViewController() // TODO: PostDetailsBuilder.makeViewController() 🔥🔥🔥
        navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
}
