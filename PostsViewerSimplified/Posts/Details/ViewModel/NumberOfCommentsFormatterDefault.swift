public final class NumberOfCommentsFormatterDefault: NumberOfCommentsFormatter {

    private typealias `Self` = NumberOfCommentsFormatterDefault

    private static let numberOfCommentsPlaceholder = "-"
    private static let noComments = "No comments"
    private static let oneComment = "One comment"

    private static func moreThanOneComment(_ numberOfComments: Int) -> String {
        return "\(numberOfComments) comments"
    }

    public init() { }

    public func formatted(numberOfComments: Int) -> String {
        switch numberOfComments {
        case 0:
            return Self.noComments
        case 1:
            return Self.oneComment
        case 2...:
            return Self.moreThanOneComment(numberOfComments)
        default:
            return Self.numberOfCommentsPlaceholder
        }
    }
}
