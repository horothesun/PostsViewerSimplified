import UIKit

enum PostsListBuilder {
    static func makeViewController() -> UIViewController {
        let httpClient = HttpClientURLSession(urlSession: URLSession.shared)
        let allPostsUseCase = AllPostsRemoteUseCase(httpClient: httpClient)
        let viewModel = PostsListViewModelDefault(
            allPostsUseCase: allPostsUseCase,
            processingQueue: .global(qos: .userInitiated)
        )
        return PostsListTableViewController(viewModel: viewModel)
    }
}
