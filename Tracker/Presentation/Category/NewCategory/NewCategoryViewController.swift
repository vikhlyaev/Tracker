import UIKit

final class NewCategoryViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(with: "Новая категория")
    private lazy var newCategoryNameTextField = AppTextField(with: "Введите название категории")
    
    private lazy var finishedButton = AppButton(title: "Готово") { [weak self] in
        guard
            let self,
            let text = self.newCategoryNameTextField.text,
            text != ""
        else { return }
        self.delegate?.didCreateNewCategory(with: text)
        self.dismiss(animated: true)
    }
    
    private weak var delegate: NewCategoryDelegate?
    
    // MARK: - Life Cycle
    
    init(delegate: NewCategoryDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setDelegates()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(newCategoryNameTextField)
        view.addSubview(finishedButton)
        finishedButton.isEnabled = false
    }
    
    private func setDelegates() {
        newCategoryNameTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        let symbols = text.filter { $0.isNumber || $0.isLetter || $0.isSymbol || $0.isPunctuation }.count
        finishedButton.isEnabled = symbols != 0
    }
}

// MARK: - Setting Constraints

extension NewCategoryViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            newCategoryNameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            newCategoryNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newCategoryNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            finishedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            finishedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            finishedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

