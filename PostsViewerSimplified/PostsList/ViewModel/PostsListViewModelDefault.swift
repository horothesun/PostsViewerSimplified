import Foundation

public final class PostsListViewModelDefault {

    private typealias `Self` = PostsListViewModelDefault

    private let allPostsUseCase: AllPostsUseCase
    private weak var selectedPostRepo: SelectedPostRepo?
    private weak var coordinator: PostsListCoordinator?
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
        success: @escaping (SuccessDisplayModel) -> Void,
        failure: @escaping (FailureDisplayModel) -> Void
    ) {
        DispatchQueue.main.async(execute: start)

        processingQueue.async { [allPostsUseCase] in
            allPostsUseCase.getAllPosts { resultPosts in
                let result = Self.resultDisplayModel(from: resultPosts)
                DispatchQueue.main.async { result.fold(success: success, failure: failure) }
            }
        }
    }

    public func onSelected(postDisplayModel: SuccessDisplayModel.Post) {
        selectedPostRepo?.selectedPostId = postDisplayModel.id
        coordinator?.proceedToPostDetails()
    }

    private static func resultDisplayModel(
        from resultPosts: Result<[Post], Error>
    ) -> Result<SuccessDisplayModel, FailureDisplayModel> {
        return resultPosts
            .map { posts -> [SuccessDisplayModel.Post] in
                posts.map { .init(id: $0.id, title: $0.title) }
            }
            .map(SuccessDisplayModel.init(postDisplayModels:))
            .mapError { _ in FailureDisplayModel(message: errorMessage) }
    }
}
