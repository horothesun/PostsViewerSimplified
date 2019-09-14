import XCTest
import PostsViewerSimplified

final class AllPostsRemoteUseCaseTests: XCTestCase {

    func test_getAllPostsFails_whenHttpClientFails() {
        let (httpClientMock, useCase) = makeUseCase()
        let pathExpectation = XCTestExpectation(description: "Path is https://jsonplaceholder.typicode.com/posts")
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/posts" { pathExpectation.fulfill() }
            completion(.failure(.httpStatus(500)))
        }
        let resultPostsExpectation = XCTestExpectation(description: "Getting all posts fails")
        useCase.getAllPosts { resultPosts in
            if case .failure(HttpClientError.httpStatus(500)) = resultPosts {
                resultPostsExpectation.fulfill()
            }
        }
        wait(for: [pathExpectation, resultPostsExpectation], timeout: 0.1)
    }

    func test_getAllPostsFails_whenHttpClientSucceedsWithUndecodableData() {
        let (httpClientMock, useCase) = makeUseCase()
        let pathExpectation = XCTestExpectation(description: "Path is https://jsonplaceholder.typicode.com/posts")
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/posts" { pathExpectation.fulfill() }
            let data = "<invalid JSON data>".data(using: .utf8)!
            completion(.success(data))
        }
        let resultPostsExpectation = XCTestExpectation(description: "Getting all posts fails")
        useCase.getAllPosts { resultPosts in
            if case .failure = resultPosts { resultPostsExpectation.fulfill() }
        }
        wait(for: [pathExpectation, resultPostsExpectation], timeout: 0.1)
    }

    func test_getAllPostsSucceedsWith2Posts_whenHttpClientSucceedsWith2Posts() {
        let (httpClientMock, useCase) = makeUseCase()
        let pathExpectation = XCTestExpectation(description: "Path is https://jsonplaceholder.typicode.com/posts")
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/posts" { pathExpectation.fulfill() }
            let data = """
                [
                    {"id": 1, "userId": 1, "title": "title_1", "body": "body_1"},
                    {"id": 2, "userId": 1, "title": "title_2", "body": "body_2"}
                ]
                """.data(using: .utf8)!
            completion(.success(data))
        }
        let resultPostsExpectation = XCTestExpectation(description: "Getting all posts 2 posts")
        useCase.getAllPosts { resultPosts in
            if case let .success(posts) = resultPosts,
                posts == [.init(id: 1, title: "title_1"), .init(id: 2, title: "title_2")] {
                resultPostsExpectation.fulfill()
            }
        }
        wait(for: [pathExpectation, resultPostsExpectation], timeout: 0.1)
    }
}

extension AllPostsRemoteUseCaseTests {
    private func makeUseCase() -> (MockHttpClient, AllPostsRemoteUseCase) {
        let httpClientMock = MockHttpClient()
        let useCase = AllPostsRemoteUseCase(httpClient: httpClientMock)
        return (httpClientMock, useCase)
    }
}

extension Post: Equatable {
    public static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
