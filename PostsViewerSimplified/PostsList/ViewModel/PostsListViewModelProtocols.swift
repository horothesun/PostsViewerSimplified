import Foundation

public struct SuccessDisplayModel {
    public struct Post {
        public let id: Int
        public let title: String

        public init(id: Int, title: String) {
            self.id = id
            self.title = title
        }
    }

    public let postDisplayModels: [Post]
}

public struct FailureDisplayModel: Error {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}

public protocol PostsListViewModel {
    func title() -> String
    func updateDisplayModel(
        start: @escaping () -> Void,
        success: @escaping (SuccessDisplayModel) -> Void,
        failure: @escaping (FailureDisplayModel) -> Void
    )
    func onSelected(postDisplayModel: SuccessDisplayModel.Post)
}

public protocol SelectedPostRepo: class {
    var selectedPostId: Int? { get set }
}

public protocol PostsListCoordinator: class {
    func proceedToPostDetails()
}
