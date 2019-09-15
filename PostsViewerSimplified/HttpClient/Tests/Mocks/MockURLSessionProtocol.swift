import Foundation
import PostsViewerSimplified

final class MockURLSessionProtocol: URLSessionProtocol {

    var dataResult: Data?
    var statusCodeResult: Int?
    var errorResult: Error?

    var dataTaskResult = MockURLSessionDataTask()
    private(set) var lastRequest: URLRequest?

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTaskProtocol {
        lastRequest = request
        let responseResult = statusCodeResult.map {
            HTTPURLResponse(
                url: URL(string: "abc.org")!,
                statusCode: $0,
                httpVersion: nil,
                headerFields: nil
            )!
        }
        completionHandler(dataResult, responseResult, errorResult)
        return dataTaskResult
    }
}
