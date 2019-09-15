import Foundation

public final class AuthorRemoteUseCase {

    private typealias `Self` = AuthorRemoteUseCase

    private let httpClient: HttpClient

    public init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
}

extension AuthorRemoteUseCase: AuthorUseCase {

    private static var basePath: String { return "https://jsonplaceholder.typicode.com/" }

    private enum UseCaseError: Error { case jsonDecodingError }

    private struct DecodedUser: Decodable {
        let id: Int
        let name: String
    }

    public func getAuthor(
        for id: Int,
        completion: @escaping (Result<PostDetails.Author, Error>) -> Void
    ) {
        httpClient.fetch(path: "\(Self.basePath)users/\(id)") { resultData in
            completion(Self.resultAuthor(from: resultData))
        }
    }

    private static func resultAuthor(
        from resultData: Result<Data, HttpClientError>
    ) -> Result<PostDetails.Author, Error> {
        return resultData
            .mapError { $0 as Error }
            .flatMap { data -> Result<DecodedUser, Error> in
                guard let decodedUser = try? JSONDecoder().decode(DecodedUser.self, from: data) else {
                    return .failure(UseCaseError.jsonDecodingError)
                }

                return .success(decodedUser)
            }
            .map { PostDetails.Author(id: $0.id, name: $0.name) }
    }
}
