import XCTest
import PostsViewerSimplified

final class HttpClientURLSessionTests: XCTestCase {

    func test_fetchFails_withInvalidPath() {
        let (urlSessionMock, httpClient) = makeHttpClient()
        let resultDataExpectation = XCTestExpectation(description: "Result data must be a failure")
        httpClient.fetch(path: "") { resultData in
            if case .failure(.invalidPath) = resultData { resultDataExpectation.fulfill() }
        }
        XCTAssertNil(urlSessionMock.lastRequest)
        XCTAssertFalse(urlSessionMock.dataTaskResult.wasResumeCalled)
    }

    func test_fetchForwardsToURLSession_whenPathIsValid() {
        let (urlSessionMock, httpClient) = makeHttpClient()
        let path = "abc.org"
        urlSessionMock.errorResult = FakeError()
        httpClient.fetch(path: path) { _ in }
        XCTAssertEqual(urlSessionMock.lastRequest?.url?.absoluteString, path)
        XCTAssert(urlSessionMock.dataTaskResult.wasResumeCalled)
    }

    func test_fetchReturnsError_whenPathIsValid_withValidData_statusCode400_errorNil() {
        let (urlSessionMock, httpClient) = makeHttpClient()
        urlSessionMock.dataResult = "{\"invalidResponse\":1}".data(using: .utf8)!
        urlSessionMock.statusCodeResult = 400
        urlSessionMock.errorResult = nil
        let resultDataExpectation = XCTestExpectation(description: "Result data must be a failure")
        httpClient.fetch(path: "abc.org") { resultData in
            if case .failure = resultData { resultDataExpectation.fulfill() }
        }
        wait(for: [resultDataExpectation], timeout: 0.1)
    }

    func test_fetchReturnsError_whenPathIsValid_withDataNil_statusCode400_errorNotNil() {
        let (urlSessionMock, httpClient) = makeHttpClient()
        urlSessionMock.dataResult = nil
        urlSessionMock.statusCodeResult = 400
        urlSessionMock.errorResult = FakeError()
        let resultDataExpectation = XCTestExpectation(description: "Result data must be a failure")
        httpClient.fetch(path: "abc.org") { resultData in
            if case .failure = resultData { resultDataExpectation.fulfill() }
        }
        wait(for: [resultDataExpectation], timeout: 0.1)
    }

    func test_fetchReturnsData_whenPathIsValid_withValidData_statusCode200_errorNil() {
        let (urlSessionMock, httpClient) = makeHttpClient()
        let jsonText = "{\"id\":1}"
        urlSessionMock.dataResult = jsonText.data(using: .utf8)!
        urlSessionMock.statusCodeResult = 200
        urlSessionMock.errorResult = nil
        let resultDataExpectation = XCTestExpectation(description: "Result data must be correct")
        httpClient.fetch(path: "abc.org") { resultData in
            if case let .success(data) = resultData,
                String(data: data, encoding: .utf8) == jsonText {
                resultDataExpectation.fulfill()
            }
        }
        wait(for: [resultDataExpectation], timeout: 0.1)
    }
}

extension HttpClientURLSessionTests {

    private struct FakeError: Error { }

    private func makeHttpClient() -> (MockURLSessionProtocol, HttpClientURLSession) {
        let urlSessionMock = MockURLSessionProtocol()
        let httpClient = HttpClientURLSession(urlSession: urlSessionMock)
        return (urlSessionMock, httpClient)
    }
}
