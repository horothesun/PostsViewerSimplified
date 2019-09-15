import XCTest
import PostsViewerSimplified

final class PostDetailsViewModelDefaultTests: XCTestCase {

    func test_titleIsDetails() {
        let (_, _, _, viewModel) = makeViewModel()
        XCTAssertEqual(viewModel.title(), "Details")
    }

    func test_callStartAndFailure_withNoSelectedPostId() {
        let (_, selectedPostRepoMock, _, viewModel) = makeViewModel()
        selectedPostRepoMock.selectedPostId = nil
        let startRunsOnMainThread = XCTestExpectation(description: "Start block called on main thread")
        let successNotCalled = XCTestExpectation(description: "Success block not called")
        successNotCalled.isInverted = true
        let failureRunsOnMainThread = XCTestExpectation(description: "Failure block called on main thread")
        viewModel.updateDisplayModel(
            start: { if Thread.isMainThread { startRunsOnMainThread.fulfill() } },
            success: { _ in successNotCalled.fulfill() },
            failure: { _ in if Thread.isMainThread { failureRunsOnMainThread.fulfill() } }
        )
        wait(
            for: [startRunsOnMainThread, successNotCalled, failureRunsOnMainThread],
            timeout: 0.1
        )
    }

    func test_callStartAndFailure_withSelectedPostId_whenPostDetailsUseCaseFails() {
        let (postDetailsUseCaseMock, selectedPostRepoMock, _, viewModel) = makeViewModel()
        postDetailsUseCaseMock.resultPostDetails = .failure(FakeError())
        selectedPostRepoMock.selectedPostId = 1
        let startRunsOnMainThread = XCTestExpectation(description: "Start block called on main thread")
        let successNotCalled = XCTestExpectation(description: "Success block not called")
        successNotCalled.isInverted = true
        let failureRunsOnMainThread = XCTestExpectation(description: "Failure block called on main thread")
        viewModel.updateDisplayModel(
            start: { if Thread.isMainThread { startRunsOnMainThread.fulfill() } },
            success: { _ in successNotCalled.fulfill() },
            failure: { _ in if Thread.isMainThread { failureRunsOnMainThread.fulfill() } }
        )
        wait(
            for: [startRunsOnMainThread, successNotCalled, failureRunsOnMainThread],
            timeout: 0.1
        )
    }

    func test_callStartAndSuccess_withSelectedPostId_whenPostDetailsUseCaseSucceeds() {
        let (postDetailsUseCaseMock, selectedPostRepoMock, numberOfCommentsFormatterMock, viewModel) = makeViewModel()
        postDetailsUseCaseMock.resultPostDetails = .success(
            .init(title: "title_1", content: "content_1", authorName: "name", numberOfComments: 2)
        )
        selectedPostRepoMock.selectedPostId = 1
        numberOfCommentsFormatterMock.result = "X comments"
        let startRunsOnMainThread = XCTestExpectation(description: "Start block called on main thread")
        let successRunsOnMainThread = XCTestExpectation(description: "Success block called on main thread")
        let failureNotCalled = XCTestExpectation(description: "Failure block not called")
        failureNotCalled.isInverted = true
        let successDisplayModelExpectation = XCTestExpectation(description: "Success display-model is correct")
        viewModel.updateDisplayModel(
            start: { if Thread.isMainThread { startRunsOnMainThread.fulfill() } },
            success: { successDisplayModel in
                if Thread.isMainThread { successRunsOnMainThread.fulfill() }
                if successDisplayModel.postDetails == .init(
                    title: "title_1",
                    content: "content_1",
                    authorName: "name",
                    numberOfComments: "X comments"
                ) {
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

extension PostDetailsViewModelDefaultTests {

    private struct FakeError: Error { }

    private func makeViewModel() -> (
        MockPostDetailsUseCase, MockSelectedPostRepo, MockNumberOfCommentsFormatter, PostDetailsViewModelDefault
    ) {
        let postDetailsUseCaseMock = MockPostDetailsUseCase()
        let selectedPostRepoMock = MockSelectedPostRepo()
        let numberOfCommentsFormatterMock = MockNumberOfCommentsFormatter()
        let viewModel = PostDetailsViewModelDefault(
            postDetailsUseCase: postDetailsUseCaseMock,
            selectedPostRepo: selectedPostRepoMock,
            numberOfCommentsFormatter: numberOfCommentsFormatterMock,
            processingQueue: .global(qos: .userInitiated)
        )
        return (postDetailsUseCaseMock, selectedPostRepoMock, numberOfCommentsFormatterMock, viewModel)
    }
}

extension PostDetailsDisplayModel.Success.PostDetails: Equatable {
    public static func == (
        lhs: PostDetailsDisplayModel.Success.PostDetails,
        rhs: PostDetailsDisplayModel.Success.PostDetails
    ) -> Bool {
        return lhs.title == rhs.title
            && lhs.content == rhs.content
            && lhs.authorName == rhs.authorName
            && lhs.numberOfComments == rhs.numberOfComments
    }
}
