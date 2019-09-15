import Foundation

public enum PostDetailsDisplayModel {
    public struct Success {
        public let postDetails: PostDetails

        public struct PostDetails {
            public let title: String
            public let content: String
            public let authorName: String
            public let numberOfComments: String

            public init(title: String, content: String, authorName: String, numberOfComments: String) {
                self.title = title
                self.content = content
                self.authorName = authorName
                self.numberOfComments = numberOfComments
            }
        }
    }

    public struct Failure: Error {
        public let message: String
    }
}

public protocol PostDetailsViewModel {
    func title() -> String
    func updateDisplayModel(
        start: @escaping () -> Void,
        success: @escaping (PostDetailsDisplayModel.Success) -> Void,
        failure: @escaping (PostDetailsDisplayModel.Failure) -> Void
    )
}

public protocol NumberOfCommentsFormatter {
    func formatted(numberOfComments: Int) -> String
}
