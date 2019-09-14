import Foundation
import PostsViewerSimplified

final class MockAllPostsUseCase: AllPostsUseCase {

    var resultPosts: Result<[Post], Error>?

    func getAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let resultPosts = resultPosts else {
            fatalError("\(#function): stub not defined")
        }

        completion(resultPosts)
    }
}
