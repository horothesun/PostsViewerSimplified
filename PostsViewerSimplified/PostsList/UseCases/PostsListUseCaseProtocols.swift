import Foundation

public struct Post {
    public let id: Int
    public let title: String

    public init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}

public protocol AllPostsUseCase {
    func getAllPosts(completion: @escaping (Result<[Post], Error>) -> Void)
}
