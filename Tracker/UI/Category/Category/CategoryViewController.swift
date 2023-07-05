import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(title: "Категория")
    
    private lazy var placeholderView = AppPlaceholderView(image: UIImage.emptyList, text: "Привычки и события можно объединить по смыслу")
    
    private lazy var tableView: AppTableView = {
        let tableView = AppTableView(frame: .zero)
        tableView.bounces = false
        tableView.allowsMultipleSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .appGray
        tableView.registerReusableCell(cellType: CategoryCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addCategoryButton: AppButton = {
        let button = AppButton(title: "Добавить категорию")
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - ViewModel
    
    var viewModel: CategoryViewModelProtocol? {
        didSet {
            viewModel?.viewModelDidChange = { [weak self] viewModel in
                self?.isEmptyCategories()
                self?.tableView.reloadData()
            }
        }
    }
    
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
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
    }
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func isEmptyCategories() {
        guard let viewModel else { return }
        viewModel.isEmpty ? showPlaceholder() : showCollectionView()
    }
    
    private func showPlaceholder() {
        placeholderView.isHidden = false
        tableView.isHidden = true
    }
    
    private func showCollectionView() {
        placeholderView.isHidden = true
        tableView.isHidden = false
    }
    
    private func isSelectedCell(at indexPath: IndexPath) -> Bool {
        guard let selectedCategoryIndexPath = viewModel?.selectedCategoryIndexPath else { return false }
        return indexPath == selectedCategoryIndexPath
    }
    
    private func setSelected(_ cell: UITableViewCell) {
        cell.accessoryType = .checkmark
        cell.setSelected(true, animated: true)
    }
    
    // MARK: - Actions
    
    @objc
    private func addButtonTapped() {
        let newCategoryViewController = NewCategoryViewController(delegate: self)
        present(newCategoryViewController, animated: true)
    }
}

// MARK: - NewCategoryDelegate

extension CategoryViewController: NewCategoryDelegate {
    func didCreateNewCategory(_ category: Category) {
        viewModel?.addCategory(category)
        isEmptyCategories()
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: CategoryCell.self)
        cell.viewModel = viewModel?.cellViewModel(at: indexPath)
        if isSelectedCell(at: indexPath) {
            setSelected(cell)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .checkmark
        viewModel?.didSelectRow(at: indexPath)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: .greatestFiniteMagnitude
            )
        } else {
            cell.separatorInset = UIEdgeInsets(
                top: 0,
                left: 16,
                bottom: 0,
                right: 16
            )
        }
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
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor, constant: -16),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

