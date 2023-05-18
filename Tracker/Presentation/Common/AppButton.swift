import UIKit

final class AppButton: UIButton {
    
    convenience init(with title: String) {
        self.init(type: .system)
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
        
        translatesAutoresizingMaskIntoConstraints = false
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
