import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI

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
        setDatePickerConstraints()
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
        /// Вопрос ревьюеру: добавление subview на UINavigationController - это нормальное решение?
        /// Или же просто оставить UIDatePicker в RightBarButtonItem?
        navigationController?.navigationBar.addSubview(datePicker)
//        navigationItem.rightBarButtonItem = setupRightBarButtonItem()
        
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
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
    
//    private func setupRightBarButtonItem() -> UIBarButtonItem {
//        let datePicker: UIDatePicker = {
//            let datePicker = UIDatePicker()
//            datePicker.preferredDatePickerStyle = .compact
//            datePicker.datePickerMode = .date
//            return datePicker
//        }()
//        return UIBarButtonItem(customView: datePicker)
//    }
    
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
    
    private func setDatePickerConstraints() {
        if let navigationController {
            NSLayoutConstraint.activate([
                datePicker.bottomAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor, constant: -60),
                datePicker.trailingAnchor.constraint(equalTo: navigationController.navigationBar.trailingAnchor, constant: -16)
            ])
        }
    }
}

