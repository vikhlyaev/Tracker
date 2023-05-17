import UIKit

final class StatisticViewController: UIViewController {
    
    private lazy var emptyStatisticImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Images.statisticEmptyStatistic)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyStatisticLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.statisticEmptyStatistic
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .appBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(emptyStatisticImageView)
        view.addSubview(emptyStatisticLabel)
    }
    
    private func setupNavigationBar() {
        title = Constants.Text.statisticTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Setting Constraints

extension StatisticViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            emptyStatisticImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStatisticImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStatisticImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStatisticImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStatisticLabel.topAnchor.constraint(equalTo: emptyStatisticImageView.bottomAnchor, constant: 8),
            emptyStatisticLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyStatisticLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emptyStatisticLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}

