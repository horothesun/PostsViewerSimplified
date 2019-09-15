import XCTest
import PostsViewerSimplified

final class CommentsRemoteUseCaseTests: XCTestCase {

    func test_getCommentsFails_whenHttpClientFails() {
        let (httpClientMock, useCase) = makeUseCase()
        let postId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/comments?postId=\(postId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/comments?postId=1" { pathExpectation.fulfill() }
            completion(.failure(.httpStatus(500)))
        }
        let resultCommentsExpectation = XCTestExpectation(description: "Getting comments fails")
        useCase.getComments(forPostId: postId) { resultComments in
            if case .failure(HttpClientError.httpStatus(500)) = resultComments {
                resultCommentsExpectation.fulfill()
            }
        }
        wait(for: [pathExpectation, resultCommentsExpectation], timeout: 0.1)
    }

    func test_getCommentsFails_whenHttpClientSucceedsWithUndecodableData() {
        let (httpClientMock, useCase) = makeUseCase()
        let postId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/comments?postId=\(postId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/comments?postId=1" { pathExpectation.fulfill() }
            let data = "<invalid JSON data>".data(using: .utf8)!
            completion(.success(data))
        }
        let resultCommentsExpectation = XCTestExpectation(description: "Getting comments fails")
        useCase.getComments(forPostId: postId) { resultComments in
            if case .failure = resultComments { resultCommentsExpectation.fulfill() }
        }
        wait(for: [pathExpectation, resultCommentsExpectation], timeout: 0.1)
    }

    func test_getCommentsSucceeds_whenHttpClientSucceeds() {
        let (httpClientMock, useCase) = makeUseCase()
        let postId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/comments?postId=\(postId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/comments?postId=1" { pathExpectation.fulfill() }
            let data = """
                [{"id": 1}, {"id": 2}]
                """.data(using: .utf8)!
            completion(.success(data))
        }
        let resultCommentsExpectation = XCTestExpectation(description: "Getting comments succeeds")
        useCase.getComments(forPostId: postId) { resultComments in
            if case let .success(comments) = resultComments,
                comments == [.init(id: 1), .init(id: 2)] {
                resultCommentsExpectation.fulfill()
            }
        }
        wait(for: [pathExpectation, resultCommentsExpectation], timeout: 0.1)
    }
}

extension CommentsRemoteUseCaseTests {
    private func makeUseCase() -> (MockHttpClient, CommentsRemoteUseCase) {
        let httpClientMock = MockHttpClient()
        let useCase = CommentsRemoteUseCase(httpClient: httpClientMock)
        return (httpClientMock, useCase)
    }
}

extension PostDetails.Comment: Equatable {
    public static func == (lhs: PostDetails.Comment, rhs: PostDetails.Comment) -> Bool {
        return lhs.id == rhs.id
    }
}
