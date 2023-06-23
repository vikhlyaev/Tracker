import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(with: "Создание трекера")
    
    private lazy var habitButton = AppButton(title: "Привычка") { [weak self] in
        self?.present(NewTrackerViewController(with: .habit), animated: true)
    }
    
    private lazy var irregularEventsButton = AppButton(title: "Нерегулярные событие") { [weak self] in
        self?.present(NewTrackerViewController(with: .irregularEvent), animated: true)
    }
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [habitButton, irregularEventsButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

