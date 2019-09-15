import Foundation

public struct PostDetails {
    public let title: String
    public let content: String
    public let authorName: String
    public let numberOfComments: Int

    public init(title: String, content: String, authorName: String, numberOfComments: Int) {
        self.title = title
        self.content = content
        self.authorName = authorName
        self.numberOfComments = numberOfComments
    }

    public struct Post {
        public let id: Int
        public let authorId: Int
        public let title: String
        public let content: String

        public init(id: Int, authorId: Int, title: String, content: String) {
            self.id = id
            self.authorId = authorId
            self.title = title
            self.content = content
        }
    }

    public struct Author {
        public let id: Int
        public let name: String

        public init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
    }

    public struct Comment {
        public let id: Int
        public init(id: Int) { self.id = id }
    }
}

public protocol PostDetailsUseCase {
    func getPostDetails(
        for postId: Int,
        completion: @escaping (Result<PostDetails, Error>) -> Void
    )
}

public protocol PostUseCase {
    func getPost(
        for id: Int,
        completion: @escaping (Result<PostDetails.Post, Error>) -> Void
    )
}

public protocol AuthorUseCase {
    func getAuthor(
        for id: Int,
        completion: @escaping (Result<PostDetails.Author, Error>) -> Void
    )
}

public protocol CommentsUseCase {
    func getComments(
        forPostId postId: Int,
        completion: @escaping (Result<[PostDetails.Comment], Error>) -> Void
    )
}
