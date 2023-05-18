import UIKit

final class TrackersViewController: UIViewController {
    
    private lazy var emptyTrackerListImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Images.trackersEmptyTrackerList)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyTrackerListLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Text.trackersEmptyTrackerList
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
        view.backgroundColor = .appWhite
        view.addSubview(emptyTrackerListImageView)
        view.addSubview(emptyTrackerListLabel)
    }
    
    private func setupNavigationBar() {
        title = Constants.Text.trackersTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .appBlack
        navigationItem.leftBarButtonItem = setupLeftBarButtonItem()
        navigationItem.rightBarButtonItem = setupRightBarButtonItem()
    }
    
    private func setupLeftBarButtonItem() -> UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)
            ),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
    }
    
    private func setupRightBarButtonItem() -> UIBarButtonItem {
        let datePicker: UIDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.preferredDatePickerStyle = .compact
            datePicker.datePickerMode = .date
            return datePicker
        }()
        
        return UIBarButtonItem(customView: datePicker)
    }
    
    @objc
    private func addButtonTapped() {
        let creatingTrackerViewController = CreatingTrackerViewController()
        present(creatingTrackerViewController, animated: true)
    }
}

// MARK: - Setting Constraints

extension TrackersViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            emptyTrackerListImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyTrackerListImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTrackerListImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyTrackerListImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyTrackerListLabel.topAnchor.constraint(equalTo: emptyTrackerListImageView.bottomAnchor, constant: 8),
            emptyTrackerListLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            emptyTrackerListLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emptyTrackerListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}

