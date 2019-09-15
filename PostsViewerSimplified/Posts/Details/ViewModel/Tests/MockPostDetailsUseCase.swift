import PostsViewerSimplified

final class MockPostDetailsUseCase: PostDetailsUseCase {

    var resultPostDetails: Result<PostDetails, Error>?

    func getPostDetails(
        for postId: Int,
        completion: @escaping (Result<PostDetails, Error>) -> Void
    ) {
        guard let resultPostDetails = resultPostDetails else {
            fatalError("\(#function): stub not defined")
        }

        completion(resultPostDetails)
    }
}
