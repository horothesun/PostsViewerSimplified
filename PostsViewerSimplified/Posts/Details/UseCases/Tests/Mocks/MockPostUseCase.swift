import Foundation
import PostsViewerSimplified

final class MockPostUseCase: PostUseCase {

    var resultPost: Result<PostDetails.Post, Error>?

    func getPost(for id: Int, completion: @escaping (Result<PostDetails.Post, Error>) -> Void) {
        guard let resultPost = resultPost else {
            fatalError("\(#function): stub not defined")
        }

        completion(resultPost)
    }
}
