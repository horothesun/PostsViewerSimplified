import XCTest
import PostsViewerSimplified

final class NumberOfCommentsFormatterDefaultTests: XCTestCase {

    func test_formattedTextIsDash_whenNumberOfCommentsIsNegative() {
        let formatter = NumberOfCommentsFormatterDefault()
        XCTAssertEqual(formatter.formatted(numberOfComments: -10), "-")
    }

    func test_formattedTextIsNoComments_whenNumberOfCommentsIs0() {
        let formatter = NumberOfCommentsFormatterDefault()
        XCTAssertEqual(formatter.formatted(numberOfComments: 0), "No comments")
    }

    func test_formattedTextIsOneComment_whenNumberOfCommentsIs1() {
        let formatter = NumberOfCommentsFormatterDefault()
        XCTAssertEqual(formatter.formatted(numberOfComments: 1), "One comment")
    }

    func test_formattedTextIs3Comments_whenNumberOfCommentsIs3() {
        let formatter = NumberOfCommentsFormatterDefault()
        XCTAssertEqual(formatter.formatted(numberOfComments: 3), "3 comments")
    }
}
