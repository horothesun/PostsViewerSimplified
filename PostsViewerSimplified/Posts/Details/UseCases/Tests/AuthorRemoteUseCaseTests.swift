import XCTest
import PostsViewerSimplified

final class AuthorRemoteUseCaseTests: XCTestCase {

    func test_getAuthorFails_whenHttpClientFails() {
        let (httpClientMock, useCase) = makeUseCase()
        let authorId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/users/\(authorId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/users/1" { pathExpectation.fulfill() }
            completion(.failure(.httpStatus(500)))
        }
        let resultAuthorExpectation = XCTestExpectation(description: "Getting user fails")
        useCase.getAuthor(for: authorId) { resultAuthor in
            if case .failure(HttpClientError.httpStatus(500)) = resultAuthor {
                resultAuthorExpectation.fulfill()
            }
        }
        wait(for: [pathExpectation, resultAuthorExpectation], timeout: 0.1)
    }

    func test_getAuthorFails_whenHttpClientSucceedsWithUndecodableData() {
        let (httpClientMock, useCase) = makeUseCase()
        let authorId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/users/\(authorId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/users/1" { pathExpectation.fulfill() }
            let data = "<invalid JSON data>".data(using: .utf8)!
            completion(.success(data))
        }
        let resultAuthorExpectation = XCTestExpectation(description: "Getting author fails")
        useCase.getAuthor(for: authorId) { resultAuthor in
            if case .failure = resultAuthor { resultAuthorExpectation.fulfill() }
        }
        wait(for: [pathExpectation, resultAuthorExpectation], timeout: 0.1)
    }

    func test_getAuthorSucceeds_whenHttpClientSucceeds() {
        let (httpClientMock, useCase) = makeUseCase()
        let authorId = 1
        let pathExpectation = XCTestExpectation(
            description: "Path is https://jsonplaceholder.typicode.com/users/\(authorId)"
        )
        httpClientMock.fetchFromPathWithCompletion = { path, completion in
            if path == "https://jsonplaceholder.typicode.com/users/1" { pathExpectation.fulfill() }
            let data = """
                {"id": 1, "name": "name"}
                """.data(using: .utf8)!
            completion(.success(data))
        }
        let resultAuthorExpectation = XCTestExpectation(description: "Getting author succeeds")
        useCase.getAuthor(for: authorId) { resultAuthor in
            if case let .success(author) = resultAuthor,
                author == .init(id: 1, name: "name") {
                resultAuthorExpectation.fulfill()
            }
        }
        wait(for: [pathExpectation, resultAuthorExpectation], timeout: 0.1)
    }
}

extension AuthorRemoteUseCaseTests {
    private func makeUseCase() -> (MockHttpClient, AuthorRemoteUseCase) {
        let httpClientMock = MockHttpClient()
        let useCase = AuthorRemoteUseCase(httpClient: httpClientMock)
        return (httpClientMock, useCase)
    }
}

extension PostDetails.Author: Equatable {
    public static func == (lhs: PostDetails.Author, rhs: PostDetails.Author) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
