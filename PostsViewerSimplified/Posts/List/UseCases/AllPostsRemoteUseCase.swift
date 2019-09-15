import Foundation

public final class AllPostsRemoteUseCase {

    private typealias `Self` = AllPostsRemoteUseCase

    private let httpClient: HttpClient

    public init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
}

extension AllPostsRemoteUseCase: AllPostsUseCase {

    private static var basePath: String { return "https://jsonplaceholder.typicode.com/" }

    private enum UseCaseError: Error { case jsonDecodingError }

    private struct DecodedPost: Decodable {
        let id: Int
        let title: String
    }

    public func getAllPosts(completion: @escaping (Result<[PostsList.Post], Error>) -> Void) {
        httpClient.fetch(path: "\(Self.basePath)posts") { resultData in
            completion(Self.resultPosts(from: resultData))
        }
    }

    private static func resultPosts(
        from resultData: Result<Data, HttpClientError>
    ) -> Result<[PostsList.Post], Error> {
        return resultData
            .mapError { $0 as Error }
            .flatMap { data -> Result<[DecodedPost], Error> in
                guard let decodedPosts = try? JSONDecoder().decode([DecodedPost].self, from: data) else {
                    return .failure(UseCaseError.jsonDecodingError)
                }

                return .success(decodedPosts)
            }
            .map { decodedPosts -> [PostsList.Post] in
                decodedPosts.map { .init(id: $0.id, title: $0.title) }
            }
    }
}
