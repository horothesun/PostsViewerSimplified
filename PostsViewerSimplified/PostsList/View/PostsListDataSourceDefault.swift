import UIKit

public final class PostsListDataSourceDefault: NSObject, PostsListDataSource {

    private typealias `Self` = PostsListDataSourceDefault

    private var postDisplayModels: [SuccessDisplayModel.Post]?
    private weak var tableView: UITableView?
    private var onSelection: ((SuccessDisplayModel.Post) -> Void)?

    private static let cellReuseIdentifier = "cellReuseIdentifier"

    public func set(
        tableView: UITableView,
        onSelection: @escaping (SuccessDisplayModel.Post) -> Void
    ) {
        self.tableView = tableView
        self.onSelection = onSelection

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellReuseIdentifier)
    }

    public func update(postDisplayModels: [SuccessDisplayModel.Post]?) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator

        guard let postDisplayModels = postDisplayModels else {
            cell.textLabel?.text = nil
            return cell
        }

        let displayModel = postDisplayModels[indexPath.row]
        cell.textLabel?.text = displayModel.title
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
}
