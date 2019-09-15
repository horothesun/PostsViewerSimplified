import Foundation

public final class PostRemoteUseCase {

    private typealias `Self` = PostRemoteUseCase

    private let httpClient: HttpClient

    public init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
}

extension PostRemoteUseCase: PostUseCase {

    private static var basePath: String { return "https://jsonplaceholder.typicode.com/" }

    private enum UseCaseError: Error { case jsonDecodingError }

    private struct DecodedPost: Decodable {
        let id: Int
        let userId: Int
        let title: String
        let body: String
    }

    public func getPost(
        for id: Int,
        completion: @escaping (Result<PostDetails.Post, Error>) -> Void
    ) {
        httpClient.fetch(path: "\(Self.basePath)posts/\(id)") { resultData in
            completion(Self.resultPost(from: resultData))
        }
    }

    private static func resultPost(
        from resultData: Result<Data, HttpClientError>
    ) -> Result<PostDetails.Post, Error> {
        return resultData
            .mapError { $0 as Error }
            .flatMap { data -> Result<DecodedPost, Error> in
                guard let decodedPost = try? JSONDecoder().decode(DecodedPost.self, from: data) else {
                    return .failure(UseCaseError.jsonDecodingError)
                }

                return .success(decodedPost)
            }
            .map { PostDetails.Post(id: $0.id, authorId: $0.userId, title: $0.title, content: $0.body) }
    }
}
