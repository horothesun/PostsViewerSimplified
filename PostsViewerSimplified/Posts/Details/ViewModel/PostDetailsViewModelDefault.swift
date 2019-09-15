import Foundation

public final class PostDetailsViewModelDefault {

    private typealias `Self` = PostDetailsViewModelDefault

    private let postDetailsUseCase: PostDetailsUseCase
    private let selectedPostRepo: SelectedPostRepo
    private let numberOfCommentsFormatter: NumberOfCommentsFormatter
    private let processingQueue: DispatchQueue

    public init(
        postDetailsUseCase: PostDetailsUseCase,
        selectedPostRepo: SelectedPostRepo,
        numberOfCommentsFormatter: NumberOfCommentsFormatter,
        processingQueue: DispatchQueue
    ) {
        self.postDetailsUseCase = postDetailsUseCase
        self.selectedPostRepo = selectedPostRepo
        self.numberOfCommentsFormatter = numberOfCommentsFormatter
        self.processingQueue = processingQueue
    }
}

extension PostDetailsViewModelDefault: PostDetailsViewModel {

    private static var errorMessage: String { return "Ops, an error occurred 🙏" }

    public func title() -> String { return "Details" }

    public func updateDisplayModel(
        start: @escaping () -> Void,
        success: @escaping (PostDetailsDisplayModel.Success) -> Void,
        failure: @escaping (PostDetailsDisplayModel.Failure) -> Void
    ) {
        DispatchQueue.main.async(execute: start)

        processingQueue.async { [postDetailsUseCase, selectedPostRepo, numberOfCommentsFormatter] in
            guard let postId = selectedPostRepo.selectedPostId else {
                DispatchQueue.main.async { failure(.init(message: Self.errorMessage)) }
                return
            }

            postDetailsUseCase.getPostDetails(for: postId) { resultPostDetails in
                let result = Self.resultDisplayModel(
                    from: resultPostDetails,
                    with: numberOfCommentsFormatter
                )
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

    private static func resultDisplayModel(
        from resultPostDetails: Result<PostDetails, Error>,
        with numberOfCommentsFormatter: NumberOfCommentsFormatter
    ) -> Result<PostDetailsDisplayModel.Success, PostDetailsDisplayModel.Failure> {
        return resultPostDetails
            .map {
                PostDetailsDisplayModel.Success.PostDetails(
                    title: $0.title,
                    content: $0.content,
                    authorName: $0.authorName,
                    numberOfComments: numberOfCommentsFormatter
                        .formatted(numberOfComments: $0.numberOfComments)
                )
            }
            .map(PostDetailsDisplayModel.Success.init(postDetails:))
            .mapError { _ in PostDetailsDisplayModel.Failure(message: errorMessage) }
    }
}
