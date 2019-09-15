import PostsViewerSimplified

final class MockNumberOfCommentsFormatter: NumberOfCommentsFormatter {

    var result: String?

    func formatted(numberOfComments: Int) -> String {
        guard let result = result else {
            fatalError("\(#function): stub not defined")
        }

        return result
    }
}
