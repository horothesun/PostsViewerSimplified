import UIKit

public protocol PostsListDataSource: UITableViewDataSource, UITableViewDelegate {
    func set(
        tableView: UITableView,
        onSelection: @escaping (PostsListDisplayModel.Success.Post) -> Void
    )
    func update(postDisplayModels: [PostsListDisplayModel.Success.Post]?)
}

final class PostsListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableFooterView = UIView()
        tableFooterView.backgroundColor = .white
        tableView.tableFooterView = tableFooterView
        dataSource.set(tableView: tableView, onSelection: viewModel.onSelected(postDisplayModel:))
        return tableView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .gray
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    private let viewModel: PostsListViewModel
    private let dataSource: PostsListDataSource

    init(
        viewModel: PostsListViewModel,
        dataSource: PostsListDataSource
    ) {
        self.dataSource = dataSource
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title()
        view.backgroundColor = .white

        configureViewHierarchy()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.updateDisplayModel(
            start: { [weak self] in self?.onStartUpdatingDisplayModel() },
            success: { [weak self] displayModel in self?.onSuccessUpdating(displayModel) },
            failure: { [weak self] displayModel in self?.onFailureUpdating(displayModel) }
        )
    }

    private func configureViewHierarchy() {
        [tableView, activityIndicator, errorLabel].forEach(view.addSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func onStartUpdatingDisplayModel() {
        dataSource.update(postDisplayModels: nil)
        tableView.reloadData()
        activityIndicator.startAnimating()
        errorLabel.text = nil
        errorLabel.isHidden = true
    }

    private func onSuccessUpdating(_ displayModel: PostsListDisplayModel.Success) {
        dataSource.update(postDisplayModels: displayModel.postDisplayModels)
        tableView.reloadData()
        activityIndicator.stopAnimating()
        errorLabel.text = nil
        errorLabel.isHidden = true
    }

    private func onFailureUpdating(_ displayModel: PostsListDisplayModel.Failure) {
        dataSource.update(postDisplayModels: nil)
        tableView.reloadData()
        activityIndicator.stopAnimating()
        errorLabel.text = displayModel.message
        errorLabel.isHidden = false
    }
}
