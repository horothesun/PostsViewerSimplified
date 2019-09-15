import UIKit

final class PostsCoordinatorDefault {
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

extension PostsCoordinatorDefault: PostsListCoordinator {
    func proceedToPostDetails() {
        let postDetailsViewController = PostDetailsBuilder.makeViewController(selectedPostRepo: selectedPostRepo)
        navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
}
