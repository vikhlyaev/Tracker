import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var placeholderView = AppPlaceholderView(
        with: UIImage(named: Constants.Images.trackersEmptyTrackerList),
        and: Constants.Text.trackersEmptyTrackerList
    )
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
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
        view.addSubview(placeholderView)
    }
    
    private func setupNavigationBar() {
        title = Constants.Text.trackersTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .appBlack
        navigationItem.leftBarButtonItem = setupLeftBarButtonItem()
        navigationItem.rightBarButtonItem = setupRightBarButtonItem()
        
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = Constants.Text.trackersSearchPlaceholder
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
//        let creatingTrackerViewController = CreatingTrackerViewController()
//        present(creatingTrackerViewController, animated: true)
        let categoryViewController = CategoryViewController()
        present(categoryViewController, animated: true)
    }
}

// MARK: - Setting Constraints

extension TrackersViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

