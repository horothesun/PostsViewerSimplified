import PostsViewerSimplified

final class MockPostsListCoordinator: PostsListCoordinator {

    var wasProceedToPostDetailsCalled: Bool = false

    func proceedToPostDetails() {
        wasProceedToPostDetailsCalled = true
    }
}
