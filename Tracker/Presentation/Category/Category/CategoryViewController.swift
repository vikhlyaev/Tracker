import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(with: "Категория")
    private lazy var placeholderView = AppPlaceholderView(
        with: UIImage(named: "icon-empty-tracker-list"),
        and: "Привычки и события можно объединить по смыслу"
    )
    
    private lazy var categoryListTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.bounces = false
        tableView.isHidden = true
        tableView.registerReusableCell(cellType: CategoryListCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addCategoryButton = AppButton(title: "Добавить категорию") { [weak self] in
        let newCategoryViewController = NewCategoryViewController()
        self?.present(newCategoryViewController, animated: true)
    }
    
    // MARK: - Data Source
    
    private var categories: [TrackerCategory] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setDelegates()
        isEmptyCategories()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(titleLabel)
        view.addSubview(placeholderView)
        view.addSubview(categoryListTableView)
        view.addSubview(addCategoryButton)
    }
    
    private func setDelegates() {
        categoryListTableView.dataSource = self
        categoryListTableView.delegate = self
    }
    
    private func isEmptyCategories() {
        categories.isEmpty ? showPlaceholder() : showCollectionView()
    }
    
    private func showPlaceholder() {
        placeholderView.isHidden = false
        categoryListTableView.isHidden = true
    }
    
    private func showCollectionView() {
        placeholderView.isHidden = true
        categoryListTableView.isHidden = false
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: CategoryListCell.self)
        cell.configure(with: categories[indexPath.row].name)
        
//        if indexPath.row == 0 {
//            cell.layer.masksToBounds = true
//            cell.layer.cornerRadius = 16
//            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        }
//
//        let indexLastCell = categories.isEmpty ? 0 : categories.count - 1
//        if indexPath.row == indexLastCell {
//            cell.layer.masksToBounds = true
//            cell.layer.cornerRadius = 16
//            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - Setting Constraints

extension CategoryViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            categoryListTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoryListTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryListTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryListTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

