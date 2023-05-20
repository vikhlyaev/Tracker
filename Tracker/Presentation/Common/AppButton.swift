import UIKit

final class AppButton: UIButton {
    
    private var action: (() -> Void)?
    
    convenience init(with title: String, and action: @escaping () -> Void) {
        self.init(type: .system)
        self.action = action
        setTitle(title, for: .normal)
        setupButton()
        setConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = .appBlack
        layer.cornerRadius = 16
        
        tintColor = .appWhite
        
        titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel?.textColor = .appWhite
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc
    private func buttonTapped() {
        action?()
    }
}

// MARK: - Setting Constraints

extension AppButton {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
