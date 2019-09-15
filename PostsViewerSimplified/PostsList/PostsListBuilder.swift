import UIKit

enum PostsListBuilder {
    static func makeViewController(
        selectedPostRepo: SelectedPostRepo,
        coordinator: PostsListCoordinator
    ) -> UIViewController {
        let httpClient = HttpClientURLSession(urlSession: URLSession.shared)
        let allPostsUseCase = AllPostsRemoteUseCase(httpClient: httpClient)
        let viewModel = PostsListViewModelDefault(
            allPostsUseCase: allPostsUseCase,
            selectedPostRepo: selectedPostRepo,
            coordinator: coordinator,
            processingQueue: .global(qos: .userInitiated)
        )
        return PostsListViewController(
            viewModel: viewModel,
            dataSource: PostsListDataSourceDefault()
        )
    }
}
