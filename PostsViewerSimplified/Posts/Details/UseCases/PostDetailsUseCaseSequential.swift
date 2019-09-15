import Foundation

public final class PostDetailsUseCaseSequential {

    private let postUseCase: PostUseCase
    private let authorUseCase: AuthorUseCase
    private let commentsUseCase: CommentsUseCase

    public init(
        postUseCase: PostUseCase,
        authorUseCase: AuthorUseCase,
        commentsUseCase: CommentsUseCase
    ) {
        self.postUseCase = postUseCase
        self.authorUseCase = authorUseCase
        self.commentsUseCase = commentsUseCase
    }
}

extension PostDetailsUseCaseSequential: PostDetailsUseCase {

    private enum UseCaseError: Error {
        case invalidPost
        case invalidAuthor
        case invalidComments
    }

    public func getPostDetails(
        for postId: Int,
        completion: @escaping (Result<PostDetails, Error>) -> Void
    ) {
        postUseCase.getPost(for: postId) { [authorUseCase, commentsUseCase] resultPost in
            guard case let .success(post) = resultPost else {
                completion(.failure(UseCaseError.invalidPost))
                return
            }

            authorUseCase.getAuthor(for: post.authorId) { resultAuthor in
                guard case let .success(author) = resultAuthor else {
                    completion(.failure(UseCaseError.invalidAuthor))
                    return
                }

                commentsUseCase.getComments(forPostId: post.id) { resultComments in
                    guard case let .success(comments) = resultComments else {
                        completion(.failure(UseCaseError.invalidComments))
                        return
                    }

                    let postDetails = PostDetails(
                        title: post.title,
                        content: post.content,
                        authorName: author.name,
                        numberOfComments: comments.count
                    )
                    completion(.success(postDetails))
                }
            }
        }
    }
}
