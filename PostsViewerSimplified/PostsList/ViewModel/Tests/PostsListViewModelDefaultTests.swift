import XCTest
import PostsViewerSimplified

final class PostsListViewModelDefaultTests: XCTestCase {

    func test_titleIsPosts() {
        let (_, viewModel) = makeViewModel()
        XCTAssertEqual(viewModel.title(), "Posts")
    }

    func test_callStartAndFailure_whenAllPostsUseCaseFails() {
        let (allPostsUseCaseMock, viewModel) = makeViewModel()
        allPostsUseCaseMock.resultPosts = .failure(FakeError())
        let startRunsOnMainThread = XCTestExpectation(description: "Start block called on main thread")
        let successNotCalled = XCTestExpectation(description: "Success block not called")
        successNotCalled.isInverted = true
        let failureRunsOnMainThread = XCTestExpectation(description: "Failure block called on main thread")
        viewModel.displayModel(
            start: { if Thread.isMainThread { startRunsOnMainThread.fulfill() } },
            success: { _ in successNotCalled.fulfill() },
            failure: { _ in if Thread.isMainThread { failureRunsOnMainThread.fulfill() } }
        )
        wait(
            for: [startRunsOnMainThread, successNotCalled, failureRunsOnMainThread],
            timeout: 0.1
        )
    }

    func test_callStartAndSuccess_whenAllPostsUseCaseSucceeds() {
        let (allPostsUseCaseMock, viewModel) = makeViewModel()
        allPostsUseCaseMock.resultPosts = .success([
            .init(id: 1, title: "title_1"),
            .init(id: 2, title: "title_2")
        ])
        let startRunsOnMainThread = XCTestExpectation(description: "Start block called on main thread")
        let successRunsOnMainThread = XCTestExpectation(description: "Success block called on main thread")
        let failureNotCalled = XCTestExpectation(description: "Failure block not called")
        failureNotCalled.isInverted = true
        let successDisplayModelExpectation = XCTestExpectation(description: "Success display-model must contain 2 posts")
        viewModel.displayModel(
            start: { if Thread.isMainThread { startRunsOnMainThread.fulfill() } },
            success: { successDisplayModel in
                if Thread.isMainThread { successRunsOnMainThread.fulfill() }
                if successDisplayModel.postDisplayModels == [
                    .init(id: 1, title: "title_1"),
                    .init(id: 2, title: "title_2")
                ] {
                    successDisplayModelExpectation.fulfill()
                }
            },
            failure: { _ in failureNotCalled.fulfill() }
        )
        wait(
            for: [
                startRunsOnMainThread, failureNotCalled,
                successRunsOnMainThread, successDisplayModelExpectation
            ],
            timeout: 0.1
        )
    }
}

extension PostsListViewModelDefaultTests {

    private struct FakeError: Error { }

    private func makeViewModel() -> (MockAllPostsUseCase, PostsListViewModelDefault) {
        let allPostsUseCaseMock = MockAllPostsUseCase()
        let viewModel = PostsListViewModelDefault(
            allPostsUseCase: allPostsUseCaseMock,
            processingQueue: .global(qos: .userInitiated)
        )
        return (allPostsUseCaseMock, viewModel)
    }
}

extension SuccessDisplayModel.Post: Equatable {
    public static func == (lhs: SuccessDisplayModel.Post, rhs: SuccessDisplayModel.Post) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
