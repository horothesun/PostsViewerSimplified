import Foundation
import PostsViewerSimplified

final class MockCommentsUseCase: CommentsUseCase {

    var resultComments: Result<[PostDetails.Comment], Error>?

    func getComments(forPostId postId: Int, completion: @escaping (Result<[PostDetails.Comment], Error>) -> Void) {
        guard let resultComments = resultComments else {
            fatalError("\(#function): stub not defined")
        }

        completion(resultComments)
    }
}
