import Foundation

public final class WeakRef<T: AnyObject> {
    public weak var object: T?

    public init(_ object: T) {
        self.object = object
    }
}

extension WeakRef: SelectedPostRepo where T: SelectedPostRepo {
    public var selectedPostId: Int? {
        get { return object?.selectedPostId }
        set { object?.selectedPostId = newValue }
    }
}

extension WeakRef: PostsListCoordinator where T: PostsListCoordinator {
    public func proceedToPostDetails() {
        object?.proceedToPostDetails()
    }
}
