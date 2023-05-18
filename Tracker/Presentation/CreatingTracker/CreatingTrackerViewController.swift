import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.creatingTrackerTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .appBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var habitButton = AppButton(
        with: Constants.Text.creatingTrackerHabitButtonTitle
    ) { [weak self] in
        
    }
    
    private lazy var irregularEventsButton = AppButton(
        with: Constants.Text.creatingTrackerIrregularEventsTitle
    ) { [weak self] in
        
    }
    
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
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
    }
    
}

// MARK: - Setting Constraints

extension CreatingTrackerViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

