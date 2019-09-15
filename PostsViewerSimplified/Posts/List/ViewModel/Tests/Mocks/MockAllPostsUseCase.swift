import Foundation
import PostsViewerSimplified

final class MockAllPostsUseCase: AllPostsUseCase {

    var resultPosts: Result<[PostsList.Post], Error>?

    func getAllPosts(completion: @escaping (Result<[PostsList.Post], Error>) -> Void) {
        guard let resultPosts = resultPosts else {
            fatalError("\(#function): stub not defined")
        }

        completion(resultPosts)
    }
}
