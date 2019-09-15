import UIKit

public enum PostDetailsBuilder {
    public static func makeViewController(selectedPostRepo: SelectedPostRepo) -> UIViewController {
        let httpClient = HttpClientURLSession(urlSession: URLSession.shared)
        let postDetailsUseCase = PostDetailsUseCaseSequential(
            postUseCase: PostRemoteUseCase(httpClient: httpClient),
            authorUseCase: AuthorRemoteUseCase(httpClient: httpClient),
            commentsUseCase: CommentsRemoteUseCase(httpClient: httpClient)
        )
        let viewModel = PostDetailsViewModelDefault(
            postDetailsUseCase: postDetailsUseCase,
            selectedPostRepo: selectedPostRepo,
            numberOfCommentsFormatter: NumberOfCommentsFormatterDefault(),
            processingQueue: .global(qos: .userInitiated)
        )
        return PostDetailsViewController(viewModel: viewModel)
    }
}
