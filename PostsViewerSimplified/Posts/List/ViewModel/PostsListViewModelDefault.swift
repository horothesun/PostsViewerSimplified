import Foundation

public final class PostsListViewModelDefault {

    private typealias `Self` = PostsListViewModelDefault

    private let allPostsUseCase: AllPostsUseCase
    private var selectedPostRepo: SelectedPostRepo
    private let coordinator: PostsListCoordinator
    private let processingQueue: DispatchQueue

    public init(
        allPostsUseCase: AllPostsUseCase,
        selectedPostRepo: SelectedPostRepo,
        coordinator: PostsListCoordinator,
        processingQueue: DispatchQueue
    ) {
        self.allPostsUseCase = allPostsUseCase
        self.selectedPostRepo = selectedPostRepo
        self.coordinator = coordinator
        self.processingQueue = processingQueue
    }
}

extension PostsListViewModelDefault: PostsListViewModel {

    private static var errorMessage: String { return "Ops, an error occurred 🙏" }

    public func title() -> String { return "Posts" }

    public func updateDisplayModel(
        start: @escaping () -> Void,
        success: @escaping (PostsListDisplayModel.Success) -> Void,
        failure: @escaping (PostsListDisplayModel.Failure) -> Void
    ) {
        DispatchQueue.main.async(execute: start)

        processingQueue.async { [allPostsUseCase] in
            allPostsUseCase.getAllPosts { resultPosts in
                let result = Self.resultDisplayModel(from: resultPosts)
                DispatchQueue.main.async {
                    switch result {
                    case let .success(displayModel):
                        success(displayModel)
                    case let .failure(displayModel):
                        failure(displayModel)
                    }
                }
            }
        }
    }

    public func onSelected(postDisplayModel: PostsListDisplayModel.Success.Post) {
        selectedPostRepo.selectedPostId = postDisplayModel.id
        coordinator.proceedToPostDetails()
    }

    private static func resultDisplayModel(
        from resultPosts: Result<[PostsList.Post], Error>
    ) -> Result<PostsListDisplayModel.Success, PostsListDisplayModel.Failure> {
        return resultPosts
            .map { posts -> [PostsListDisplayModel.Success.Post] in
                posts.map { .init(id: $0.id, title: $0.title) }
            }
            .map(PostsListDisplayModel.Success.init(postDisplayModels:))
            .mapError { _ in PostsListDisplayModel.Failure(message: errorMessage) }
    }
}
