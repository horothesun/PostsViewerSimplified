import Foundation

public enum PostsListDisplayModel {
    public struct Success {
        public let postDisplayModels: [Post]

        public struct Post {
            public let id: Int
            public let title: String

            public init(id: Int, title: String) {
                self.id = id
                self.title = title
            }
        }
    }

    public struct Failure: Error {
        public let message: String
    }
}

public protocol PostsListViewModel {
    func title() -> String
    func updateDisplayModel(
        start: @escaping () -> Void,
        success: @escaping (PostsListDisplayModel.Success) -> Void,
        failure: @escaping (PostsListDisplayModel.Failure) -> Void
    )
    func onSelected(postDisplayModel: PostsListDisplayModel.Success.Post)
}

public protocol SelectedPostRepo {
    var selectedPostId: Int? { get set }
}

public protocol PostsListCoordinator {
    func proceedToPostDetails()
}
