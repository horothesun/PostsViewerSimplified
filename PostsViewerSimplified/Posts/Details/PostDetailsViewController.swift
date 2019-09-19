import UIKit

final class PostDetailsViewController: UIViewController {

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

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
    }()

    private lazy var postContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()

    private lazy var numberOfCommentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()

    private let viewModel: PostDetailsViewModel

    init(viewModel: PostDetailsViewModel) {
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

        viewModel.updateDisplayModel(
            start: { [weak self] in self?.onStartUpdatingDisplayModel() },
            success: { [weak self] displayModel in self?.onSuccessUpdating(displayModel) },
            failure: { [weak self] displayModel in self?.onFailureUpdating(displayModel) }
        )
    }

    private func configureViewHierarchy() {
        [
            postTitleLabel,
            authorLabel,
            postContentLabel,
            numberOfCommentsLabel
        ].forEach(containerView.addSubview(_:))
        scrollView.addSubview(containerView)
        [activityIndicator, errorLabel, scrollView].forEach(view.addSubview)
    }

    private func configureLayout() {
        guard
            let activityIndicatorSuperview = activityIndicator.superview,
            let errorLabelSuperview = errorLabel.superview,
            let postTitleLabelSuperview = postTitleLabel.superview,
            let authorLabelSuperview = authorLabel.superview,
            let postContentLabelSuperview = postContentLabel.superview,
            let numberOfCommentsLabelSuperview = numberOfCommentsLabel.superview,
            let containerViewSuperview = containerView.superview,
            let scrollViewSuperview = scrollView.superview
        else { return }

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: activityIndicatorSuperview.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: activityIndicatorSuperview.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: errorLabelSuperview.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: errorLabelSuperview.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            postTitleLabel.topAnchor.constraint(equalTo: postTitleLabelSuperview.topAnchor, constant: 15),
            postTitleLabel.leadingAnchor.constraint(equalTo: postTitleLabelSuperview.leadingAnchor, constant: 15),
            postTitleLabel.trailingAnchor.constraint(equalTo: postTitleLabelSuperview.trailingAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: authorLabelSuperview.leadingAnchor, constant: 15),
            authorLabel.trailingAnchor.constraint(equalTo: authorLabelSuperview.trailingAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            postContentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 10),
            postContentLabel.leadingAnchor.constraint(equalTo: postContentLabelSuperview.leadingAnchor, constant: 15),
            postContentLabel.trailingAnchor.constraint(equalTo: postContentLabelSuperview.trailingAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            numberOfCommentsLabel.topAnchor.constraint(equalTo: postContentLabel.bottomAnchor, constant: 10),
            numberOfCommentsLabel.trailingAnchor.constraint(equalTo: numberOfCommentsLabelSuperview.trailingAnchor, constant: -15),
            numberOfCommentsLabel.bottomAnchor.constraint(equalTo: numberOfCommentsLabelSuperview.safeAreaLayoutGuide.bottomAnchor, constant: -15)
        ])
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: containerViewSuperview.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: containerViewSuperview.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: containerViewSuperview.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: containerViewSuperview.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollViewSuperview.safeAreaLayoutGuide.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: scrollViewSuperview.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: scrollViewSuperview.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: scrollViewSuperview.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: scrollViewSuperview.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func onStartUpdatingDisplayModel() {
        scrollView.isHidden = true
        activityIndicator.startAnimating()
        errorLabel.text = nil
        errorLabel.isHidden = true
    }

    private func onSuccessUpdating(_ displayModel: PostDetailsDisplayModel.Success) {
        postTitleLabel.text = displayModel.postDetails.title
        authorLabel.text = displayModel.postDetails.authorName
        postContentLabel.text = displayModel.postDetails.content
        numberOfCommentsLabel.text = displayModel.postDetails.numberOfComments
        scrollView.isHidden = false
        activityIndicator.stopAnimating()
        errorLabel.text = nil
        errorLabel.isHidden = true
    }

    private func onFailureUpdating(_ displayModel: PostDetailsDisplayModel.Failure) {
        postTitleLabel.text = nil
        authorLabel.text = nil
        postContentLabel.text = nil
        numberOfCommentsLabel.text = nil
        scrollView.isHidden = false
        activityIndicator.stopAnimating()
        errorLabel.text = displayModel.message
        errorLabel.isHidden = false
    }
}
