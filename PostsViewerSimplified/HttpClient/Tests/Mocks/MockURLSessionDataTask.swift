import PostsViewerSimplified

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var wasResumeCalled = false
    func resume() { wasResumeCalled = true }
}
