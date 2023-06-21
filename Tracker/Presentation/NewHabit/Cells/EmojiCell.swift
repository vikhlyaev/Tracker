import UIKit

final class EmojiCell: UICollectionViewCell {
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            emojiLabel.backgroundColor = isSelected ? .appLightGray : .clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(emojiLabel)
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }
}

// MARK: - Settings Constraints

extension EmojiCell {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: topAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
