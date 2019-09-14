import Foundation

private enum UseCaseError: Error { case jsonDecodingError }

private struct DecodedPost: Decodable {
    let id: Int
    let userId: Int
    let title: String
}

public final class AllPostsRemoteUseCase {

    private typealias `Self` = AllPostsRemoteUseCase

    private let httpClient: HttpClient

    public init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
}

extension AllPostsRemoteUseCase: AllPostsUseCase {

    private static var basePath: String { return "https://jsonplaceholder.typicode.com/" }

    public func getAllPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        httpClient.fetch(path: "\(Self.basePath)posts") { resultData in
            completion(Self.resultPosts(from: resultData))
        }
    }

    private static func resultPosts(
        from resultData: Result<Data, HttpClientError>
    ) -> Result<[Post], Error> {
        return resultData
            .mapError { $0 as Error }
            .flatMap { data -> Result<[DecodedPost], Error> in
                guard let decodedPosts = try? JSONDecoder().decode([DecodedPost].self, from: data) else {
                    return .failure(UseCaseError.jsonDecodingError)
                }

                return .success(decodedPosts)
            }
            .map { decodedPosts -> [Post] in
                decodedPosts.map { Post(id: $0.id, title: $0.title) }
            }
    }
}
