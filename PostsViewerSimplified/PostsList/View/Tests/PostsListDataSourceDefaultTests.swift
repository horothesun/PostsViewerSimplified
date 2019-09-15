import XCTest
import PostsViewerSimplified

final class PostsListDataSourceDefaultTests: XCTestCase {

    func test_setTableViewAndOnSelection_setsTableViewDataSourceAndDelegate() {
        let (tableView, dataSource) = makeDataSource()
        dataSource.set(tableView: tableView, onSelection: { _ in })
        XCTAssertNotNil(tableView.dataSource)
        XCTAssertNotNil(tableView.delegate)
    }

    func test_numberOfSections_returns1() {
        let (tableView, dataSource) = makeDataSource()
        let numberOfSections = dataSource.numberOfSections(in: tableView)
        XCTAssertEqual(numberOfSections, 1)
    }

    func test_numberOfRowsInSection0_beforeSettingPostDisplayModels_returns0() {
        let (tableView, dataSource) = makeDataSource()
        let numberOfRowsInSection0 = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRowsInSection0, 0)
    }

    func test_numberOfRowsInSection0_afterSetting3PostDisplayModels_returns3() {
        let (tableView, dataSource) = makeDataSource()
        dataSource.update(postDisplayModels: [
            .init(id: 1, title: "title_1"),
            .init(id: 2, title: "title_2"),
            .init(id: 3, title: "title_3")
        ])
        let numberOfRowsInSection0 = dataSource.tableView(tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRowsInSection0, 3)
    }

    func test_cellForRowAt0_0_afterSetTableView_beforeUpdatePostDisplayModels_returnsCellWithEmptyTextLabel() {
        let (tableView, dataSource) = makeDataSource()
        dataSource.set(tableView: tableView, onSelection: { _ in })
        let cell = dataSource.tableView(tableView, cellForRowAt: .init(row: 0, section: 0))
        XCTAssertNil(cell.textLabel!.text)
    }

    func test_cellForRowAt0_0_afterSetTableView_afterUpdatePostDisplayModels_returnsCellWithFirstTitle() {
        let (tableView, dataSource) = makeDataSource()
        dataSource.set(tableView: tableView, onSelection: { _ in })
        dataSource.update(postDisplayModels: [.init(id: 1, title: "title_1"), .init(id: 2, title: "title_2")])
        let cell = dataSource.tableView(tableView, cellForRowAt: .init(row: 0, section: 0))
        XCTAssertEqual(cell.textLabel!.text, "title_1")
    }

    func test_didSelectRowAt0_0_afterSetTableView_beforeUpdatePostDisplayModels_doesNotCallOnSelection() {
        let (tableView, dataSource) = makeDataSource()
        let onSelectionExpectation = XCTestExpectation(description: "onSelection not called")
        onSelectionExpectation.isInverted = true
        dataSource.set(tableView: tableView, onSelection: { _ in onSelectionExpectation.fulfill() })
        dataSource.tableView(tableView, didSelectRowAt: .init(row: 0, section: 0))
        wait(for: [onSelectionExpectation], timeout: 0.1)
    }

    func test_didSelectRowAt0_0_afterSetTableView_afterUpdatePostDisplayModels_doesNotCallOnSelection() {
        let (tableView, dataSource) = makeDataSource()
        let firstPostDisplayModel = SuccessDisplayModel.Post(id: 1, title: "title_1")
        let onSelectionExpectation = XCTestExpectation(
            description: "onSelection called with first post display-model"
        )
        dataSource.set(tableView: tableView, onSelection: { postDisplayModel in
            if postDisplayModel == firstPostDisplayModel { onSelectionExpectation.fulfill() }
        })
        dataSource.update(postDisplayModels: [firstPostDisplayModel, .init(id: 2, title: "title_2")])
        dataSource.tableView(tableView, didSelectRowAt: .init(row: 0, section: 0))
        wait(for: [onSelectionExpectation], timeout: 0.1)
    }
}

extension PostsListDataSourceDefaultTests {
    private func makeDataSource() -> (UITableView, PostsListDataSourceDefault) {
        return (UITableView(), PostsListDataSourceDefault())
    }
}
