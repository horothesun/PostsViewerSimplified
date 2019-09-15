import Foundation
import PostsViewerSimplified

final class MockAuthorUseCase: AuthorUseCase {

    var resultAuthor: Result<PostDetails.Author, Error>?

    func getAuthor(for id: Int, completion: @escaping (Result<PostDetails.Author, Error>) -> Void) {
        guard let resultAuthor = resultAuthor else {
            fatalError("\(#function): stub not defined")
        }

        completion(resultAuthor)
    }
}
