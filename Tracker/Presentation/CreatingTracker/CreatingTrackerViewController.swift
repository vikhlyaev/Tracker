import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    private lazy var habitButton = AppButton(with: Constants.Text.creatingTrackerHabitButtonTitle)
    private lazy var irregularEventsButton = AppButton(with: Constants.Text.creatingTrackerIrregularEventsTitle)
    
    private lazy var buttonsStackView = UIStackView(
        arrangedSubviews: [habitButton, irregularEventsButton],
        axis: .vertical,
        spacing: 16
    )
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(buttonsStackView)
    }
    
    private func setupNavigationBar() {
        title = Constants.Text.creatingTrackerTitle
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
}

// MARK: - Setting Constraints

extension CreatingTrackerViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

