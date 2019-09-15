import UIKit

enum PostsListBuilder {
    public static func makeViewController(
        selectedPostRepo: SelectedPostRepoDefault,
        coordinator: PostsCoordinatorDefault
    ) -> UIViewController {
        let httpClient = HttpClientURLSession(urlSession: URLSession.shared)
        let allPostsUseCase = AllPostsRemoteUseCase(httpClient: httpClient)
        let viewModel = PostsListViewModelDefault(
            allPostsUseCase: allPostsUseCase,
            selectedPostRepo: WeakRef(selectedPostRepo),
            coordinator: WeakRef(coordinator),
            processingQueue: .global(qos: .userInitiated)
        )
        return PostsListViewController(
            viewModel: viewModel,
            dataSource: PostsListDataSourceDefault()
        )
    }
}
