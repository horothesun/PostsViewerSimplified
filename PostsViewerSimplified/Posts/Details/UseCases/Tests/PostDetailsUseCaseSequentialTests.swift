import XCTest
import PostsViewerSimplified

final class PostDetailsUseCaseSequentialTests: XCTestCase {

    func test_getPostDetailsFails_whenPostUseCaseFails() {
        let (postUseCaseMock, authorUseCaseMock, commentsUseCaseMock, useCase) = makeUseCase()
        postUseCaseMock.resultPost = .failure(FakeError())
        authorUseCaseMock.resultAuthor = .success(.init(id: 1, name: "name"))
        commentsUseCaseMock.resultComments = .success([.init(id: 1), .init(id: 2)])
        let resultPostDetailsExpectation = XCTestExpectation(description: "Getting post details fails")
        useCase.getPostDetails(for: 123) { resultPostDetails in
            if case .failure = resultPostDetails { resultPostDetailsExpectation.fulfill() }
        }
        wait(for: [resultPostDetailsExpectation], timeout: 0.1)
    }

    func test_getPostDetailsFails_whenAuthorUseCaseFails() {
        let (postUseCaseMock, authorUseCaseMock, commentsUseCaseMock, useCase) = makeUseCase()
        postUseCaseMock.resultPost = .success(.init(id: 1, authorId: 1, title: "title_1", content: "content_1"))
        authorUseCaseMock.resultAuthor = .failure(FakeError())
        commentsUseCaseMock.resultComments = .success([.init(id: 1), .init(id: 2)])
        let resultPostDetailsExpectation = XCTestExpectation(description: "Getting post details fails")
        useCase.getPostDetails(for: 123) { resultPostDetails in
            if case .failure = resultPostDetails { resultPostDetailsExpectation.fulfill() }
        }
        wait(for: [resultPostDetailsExpectation], timeout: 0.1)
    }

    func test_getPostDetailsFails_whenCommentsUseCaseFails() {
        let (postUseCaseMock, authorUseCaseMock, commentsUseCaseMock, useCase) = makeUseCase()
        postUseCaseMock.resultPost = .success(.init(id: 1, authorId: 1, title: "title_1", content: "content_1"))
        authorUseCaseMock.resultAuthor = .success(.init(id: 1, name: "name"))
        commentsUseCaseMock.resultComments = .failure(FakeError())
        let resultPostDetailsExpectation = XCTestExpectation(description: "Getting post details fails")
        useCase.getPostDetails(for: 123) { resultPostDetails in
            if case .failure = resultPostDetails { resultPostDetailsExpectation.fulfill() }
        }
        wait(for: [resultPostDetailsExpectation], timeout: 0.1)
    }

    func test_getPostDetailsSucceeds_whenAllUseCasesSucceed() {
        let (postUseCaseMock, authorUseCaseMock, commentsUseCaseMock, useCase) = makeUseCase()
        postUseCaseMock.resultPost = .success(.init(id: 1, authorId: 1, title: "title_1", content: "content_1"))
        authorUseCaseMock.resultAuthor = .success(.init(id: 1, name: "name"))
        commentsUseCaseMock.resultComments = .success([.init(id: 1), .init(id: 2)])
        let expectedPostDetails = PostDetails(
            title: "title_1",
            content: "content_1",
            authorName: "name",
            numberOfComments: 2
        )
        let resultPostDetailsExpectation = XCTestExpectation(description: "Getting post details fails")
        useCase.getPostDetails(for: 123) { resultPostDetails in
            if case let .success(postDetails) = resultPostDetails,
                postDetails == expectedPostDetails {
                resultPostDetailsExpectation.fulfill()
            }
        }
        wait(for: [resultPostDetailsExpectation], timeout: 0.1)
    }
}

extension PostDetailsUseCaseSequentialTests {

    private struct FakeError: Error { }

    private func makeUseCase() -> (
        MockPostUseCase, MockAuthorUseCase, MockCommentsUseCase, PostDetailsUseCaseSequential
    ) {
        let postUseCaseMock = MockPostUseCase()
        let authorUseCaseMock = MockAuthorUseCase()
        let commentsUseCaseMock = MockCommentsUseCase()
        let useCase = PostDetailsUseCaseSequential(
            postUseCase: postUseCaseMock,
            authorUseCase: authorUseCaseMock,
            commentsUseCase: commentsUseCaseMock
        )
        return (postUseCaseMock, authorUseCaseMock, commentsUseCaseMock, useCase)
    }
}

extension PostDetails: Equatable {
    public static func == (lhs: PostDetails, rhs: PostDetails) -> Bool {
        return lhs.title == rhs.title
            && lhs.content == rhs.content
            && lhs.authorName == rhs.authorName
            && lhs.numberOfComments == rhs.numberOfComments
    }
}
