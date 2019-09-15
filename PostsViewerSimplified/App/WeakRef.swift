import Foundation

final class WeakRef<T: AnyObject> {
    weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRef: SelectedPostRepo where T: SelectedPostRepo {
    var selectedPostId: Int? {
        get { return object?.selectedPostId }
        set { object?.selectedPostId = newValue }
    }
}

extension WeakRef: PostsListCoordinator where T: PostsListCoordinator {
    func proceedToPostDetails() {
        object?.proceedToPostDetails()
    }
}
