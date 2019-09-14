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
    func displayModel(
        start: @escaping () -> Void,
        success: @escaping (SuccessDisplayModel) -> Void,
        failure: @escaping (FailureDisplayModel) -> Void
    )
}
