import UIKit

public final class PostsListDataSourceDefault: NSObject, PostsListDataSource {

    private typealias `Self` = PostsListDataSourceDefault

    private var postDisplayModels: [PostsListDisplayModel.Success.Post]?
    private weak var tableView: UITableView?
    private var onSelection: ((PostsListDisplayModel.Success.Post) -> Void)?

    private static let cellReuseIdentifier = "cellReuseIdentifier"

    public func set(
        tableView: UITableView,
        onSelection: @escaping (PostsListDisplayModel.Success.Post) -> Void
    ) {
        self.tableView = tableView
        self.onSelection = onSelection

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
    }

    public func update(postDisplayModels: [PostsListDisplayModel.Success.Post]?) {
        self.postDisplayModels = postDisplayModels
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let postDisplayModels = postDisplayModels else {
            return 0
        }

        return postDisplayModels.count
    }

    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
        guard let postDisplayModels = postDisplayModels else {
            Self.configure(cell: &cell, withText: nil)
            return cell
        }

        let displayModel = postDisplayModels[indexPath.row]
        Self.configure(cell: &cell, withText: displayModel.title)
        return cell
    }

    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard
            let postDisplayModels = postDisplayModels,
            let onSelection = onSelection
        else { return }

        let postDisplayModel = postDisplayModels[indexPath.row]
        onSelection(postDisplayModel)
    }

    private static func configure(cell: inout UITableViewCell, withText text: String?) {
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 13)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = text
    }
}
