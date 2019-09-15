import Foundation

public final class CommentsRemoteUseCase {

    private typealias `Self` = CommentsRemoteUseCase

    private let httpClient: HttpClient

    public init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
}

extension CommentsRemoteUseCase: CommentsUseCase {

    private static var basePath: String { return "https://jsonplaceholder.typicode.com/" }

    private enum UseCaseError: Error { case jsonDecodingError }

    private struct DecodedComment: Decodable { let id: Int }

    public func getComments(
        forPostId postId: Int,
        completion: @escaping (Result<[PostDetails.Comment], Error>) -> Void
    ) {
        httpClient.fetch(path: "\(Self.basePath)comments?postId=\(postId)") { resultData in
            completion(Self.resultComments(from: resultData))
        }
    }

    private static func resultComments(
        from resultData: Result<Data, HttpClientError>
    ) -> Result<[PostDetails.Comment], Error> {
        return resultData
            .mapError { $0 as Error }
            .flatMap { data -> Result<[DecodedComment], Error> in
                guard let decodedComments = try? JSONDecoder().decode([DecodedComment].self, from: data) else {
                    return .failure(UseCaseError.jsonDecodingError)
                }

                return .success(decodedComments)
            }
            .map { decodedComments -> [PostDetails.Comment] in
                decodedComments.map { .init(id: $0.id) }
            }
    }
}
