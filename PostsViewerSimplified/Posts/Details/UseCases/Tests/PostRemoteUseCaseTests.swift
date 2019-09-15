import XCTest
import PostsViewerSimplified

final class PostRemoteUseCaseTests: XCTestCase {

    func test_getPostFails_whenHttpClientFails() {
        let (httpClientMock, useCase) = makeUseCase()
        let postId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/posts/\(postId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/posts/1" { pathExpectation.fulfill() }
            completion(.failure(.httpStatus(500)))
        }
        let resultPostExpectation = XCTestExpectation(description: "Getting post fails")
        useCase.getPost(for: postId) { resultPost in
            if case .failure(HttpClientError.httpStatus(500)) = resultPost {
                resultPostExpectation.fulfill()
            }
        }
        wait(for: [pathExpectation, resultPostExpectation], timeout: 0.1)
    }

    func test_getPostFails_whenHttpClientSucceedsWithUndecodableData() {
        let (httpClientMock, useCase) = makeUseCase()
        let postId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/posts/\(postId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/posts/1" { pathExpectation.fulfill() }
            let data = "<invalid JSON data>".data(using: .utf8)!
            completion(.success(data))
        }
        let resultPostExpectation = XCTestExpectation(description: "Getting post fails")
        useCase.getPost(for: postId) { resultPost in
            if case .failure = resultPost { resultPostExpectation.fulfill() }
        }
        wait(for: [pathExpectation, resultPostExpectation], timeout: 0.1)
    }

    func test_getPostSucceeds_whenHttpClientSucceeds() {
        let (httpClientMock, useCase) = makeUseCase()
        let postId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/posts/\(postId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/posts/1" { pathExpectation.fulfill() }
            let data = """
                {"id": 1, "userId": 1, "title": "title_1", "body": "body_1"}
                """.data(using: .utf8)!
            completion(.success(data))
        }
        let resultPostExpectation = XCTestExpectation(description: "Getting post succeeds")
        useCase.getPost(for: postId) { resultPost in
            if case let .success(post) = resultPost,
                post == .init(id: 1, authorId: 1, title: "title_1", content: "body_1") {
                resultPostExpectation.fulfill()
            }
        }
        wait(for: [pathExpectation, resultPostExpectation], timeout: 0.1)
    }
}

extension PostRemoteUseCaseTests {
    private func makeUseCase() -> (MockHttpClient, PostRemoteUseCase) {
        let httpClientMock = MockHttpClient()
        let useCase = PostRemoteUseCase(httpClient: httpClientMock)
        return (httpClientMock, useCase)
    }
}

extension PostDetails.Post: Equatable {
    public static func == (lhs: PostDetails.Post, rhs: PostDetails.Post) -> Bool {
        return lhs.id == rhs.id
            && lhs.authorId == rhs.authorId
            && lhs.title == rhs.title
            && lhs.content == rhs.content
    }
}
