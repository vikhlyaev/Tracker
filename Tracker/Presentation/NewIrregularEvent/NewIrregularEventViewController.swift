import UIKit

final class NewIrregularEventViewController: UIViewController {
    
    private lazy var titleLabel = AppTitleLabel(
        with: Constants.Text.newIrregularEventTitle
    )
    
    private lazy var trackerNameTextField = AppTextField(
        with: Constants.Text.newIrregularEventTrackerNamePlaceholder
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
    }
}

// MARK: - Setting Constraints

extension NewIrregularEventViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

