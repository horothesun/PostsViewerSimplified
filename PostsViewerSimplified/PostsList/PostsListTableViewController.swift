import UIKit

final class PostsListTableViewController: UITableViewController {

    private typealias `Self` = PostsListTableViewController

    private static let reuseIdentifier = "reuseIdentifier"

    private var postDisplayModels: [SuccessDisplayModel.Post]? // TODO: move to dedicated data-source dependency

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

    init(viewModel: PostsListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewHierarchy()
        configureLayout()
        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.displayModel(
            start: { [weak self] in
                self?.postDisplayModels = nil
                self?.tableView.reloadData()
                self?.activityIndicator.startAnimating()
                self?.errorLabel.text = ""
                self?.errorLabel.isHidden = true
            },
            success: { [weak self] displayModel in
                self?.postDisplayModels = displayModel.postDisplayModels
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.errorLabel.text = ""
                self?.errorLabel.isHidden = true
            },
            failure: { [weak self] displayModel in
                self?.postDisplayModels = nil
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.errorLabel.text = displayModel.message
                self?.errorLabel.isHidden = false
            }
        )
    }

    private func configureViewHierarchy() {
        [activityIndicator, errorLabel].forEach(view.addSubview)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func configureViews() {
        title = viewModel.title()

        tableView.allowsSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.reuseIdentifier)
        let tableFooterView = UIView()
        tableFooterView.backgroundColor = .white
        tableView.tableFooterView = tableFooterView
    }
}

// MARK: - UITableViewDataSource
extension PostsListTableViewController { // TODO: move to dedicated data-source dependency
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let postDisplayModels = postDisplayModels else {
            return 0
        }

        return postDisplayModels.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
        guard let postDisplayModels = postDisplayModels else {
            return cell
        }

        let displayModel = postDisplayModels[indexPath.row]
        cell.textLabel?.text = displayModel.title
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PostsListTableViewController {
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        // TODO: ...
    }
}
