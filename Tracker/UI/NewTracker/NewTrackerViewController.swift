import UIKit

protocol NewTrackerDelegate: AnyObject {
    func didCreateNewTracker(_ tracker: Tracker, to category: Category)
}

final class NewTrackerViewController: UIViewController {
    
    // MARK: - Delegate

    private weak var delegate: NewTrackerDelegate?
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(title: trackerType.title)
    
    private lazy var textField = AppTextField(placeholder: "Введите название трекера")
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var tableView: AppTableView = {
        let tableView = AppTableView(frame: .zero)
        tableView.separatorInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        tableView.separatorColor = .appGray
        tableView.bounces = false
        tableView.registerReusableCell(cellType: SettingsCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var collectionView: AppCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = AppCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.bounces = false
        collectionView.isScrollEnabled = false
        collectionView.allowsMultipleSelection = true
        collectionView.registerReusableCell(cellType: EmojiCell.self)
        collectionView.registerReusableCell(cellType: ColorCell.self)
        collectionView.registerSupplementaryView(
            view: AppCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var createButton: AppButton = {
        let button = AppButton(title: "Создать")
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: AppButton = {
        let button = AppButton(title: "Отменить", style: .cancel)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var settings: [SettingsCollectionViewSection] = [
        .emoji([
            "🙂", "😻", "🌺", "🐶", "❤️", "😱",
            "😇", "😡", "🥶", "🤔", "🙌", "🍔",
            "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
        ]),
        .color([
            .colorSelection1, .colorSelection2, .colorSelection3,
            .colorSelection4, .colorSelection5, .colorSelection6,
            .colorSelection7, .colorSelection8, .colorSelection9,
            .colorSelection10, .colorSelection11, .colorSelection12,
            .colorSelection13, .colorSelection14, .colorSelection15,
            .colorSelection16, .colorSelection17, .colorSelection18
        ])
    ]
    
    // MARK: - Properties
    
    private let trackerType: TrackerType
    
    private var name: String? {
        didSet {
            checkRequiredSettings()
        }
    }
    
    private var selectedDays: Set<WeekDay> = []
    
    private var selectedCategory: Category? {
        didSet {
            checkRequiredSettings()
        }
    }
    
    private var selectedEmoji: String? {
        didSet {
            checkRequiredSettings()
        }
    }
    
    private var selectedColor: UIColor? {
        didSet {
            checkRequiredSettings()
        }
    }
    
    // MARK: - Life Cycle
    
    init(with trackerType: TrackerType, delegate: NewTrackerDelegate) {
        self.trackerType = trackerType
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
        view.addSubview(scrollView)
        scrollView.addSubview(textField)
        scrollView.addSubview(tableView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(buttonsStackView)
        createButton.isEnabled = false
    }
    
    private func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        textField.delegate = self
    }
    
    private func checkRequiredSettings() {
        if name != nil && selectedCategory != nil && selectedEmoji != nil && selectedColor != nil {
            createButton.isEnabled = true
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func createButtonTapped() {
        guard
            let name,
            let selectedColor,
            let selectedEmoji,
            let selectedCategory
        else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            name: name,
            color: selectedColor,
            emoji: selectedEmoji,
            schedule: selectedDays.isEmpty ? WeekDay.allCases : Array(selectedDays)
        )
        
        dismiss(animated: true)
        delegate?.didCreateNewTracker(newTracker, to: selectedCategory)
    }
    
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - CategoryDelegate

extension NewTrackerViewController: CategoryDelegate {
    func didSelectCategory(_ selectedCategory: Category) {
        self.selectedCategory = selectedCategory
        let categoryCell = tableView.visibleCells.filter({
            $0.tag == SettingsTableViewSection.category.rawValue
        }).first as? SettingsCell
        categoryCell?.updateSelectedSettings(selectedCategory.name)
    }
}

// MARK: - ScheduleDelegate

extension NewTrackerViewController: ScheduleDelegate {
    func didSelectDays(_ days: Set<WeekDay>) {
        selectedDays = days
        updateScheduleCell(days: Array(days))
    }
    
    private func updateScheduleCell(days: [WeekDay]) {
        var selectedDays: String?
        if days.count == 7 {
            selectedDays = "Каждый день"
        } else {
            selectedDays = days
                .sorted(by: { $0.rawValue < $1.rawValue })
                .map { $0.shortTitle }
                .joined(separator: ", ")
        }
        let scheduleCell = tableView.visibleCells.filter({
            $0.tag == SettingsTableViewSection.schedule.rawValue
        }).first as? SettingsCell
        scheduleCell?.updateSelectedSettings(selectedDays ?? "")
    }
}

// MARK: - UITextFieldDelegate

extension NewTrackerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""
        let symbols = text.filter { $0.isNumber || $0.isLetter || $0.isSymbol || $0.isPunctuation }.count
        if symbols != 0 { name = text }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension NewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch trackerType {
        case .habit:
            return SettingsTableViewSection.allCases.count
        case .irregularEvent:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: SettingsCell.self)
        switch trackerType {
        case .habit:
            cell.configure(
                with: SettingsTableViewSection.allCases[indexPath.row].title
            )
        case .irregularEvent:
            cell.configure(
                with: SettingsTableViewSection.category.title
            )
        }
        cell.tag = indexPath.row
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsCell else { return }
        switch cell.tag {
        case 0:
            let categoryViewController = CategoryViewController(selectedCategory: selectedCategory)
            categoryViewController.delegate = self
            present(categoryViewController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController(selectedDays: selectedDays)
            scheduleViewController.delegate = self
            present(scheduleViewController, animated: true)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UICollectionViewDataSource

extension NewTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch settings[section] {
        case .emoji(let emojiItems):
            return emojiItems.count
        case .color(let colorItems):
            return colorItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch settings[indexPath.section] {
        case .emoji(let emojiItems):
            let cell = collectionView.dequeueReusableCell(cellType: EmojiCell.self, indexPath: indexPath)
            cell.configure(with: emojiItems[indexPath.row])
            return cell
        case .color(let colorItems):
            let cell = collectionView.dequeueReusableCell(cellType: ColorCell.self, indexPath: indexPath)
            cell.configure(with: colorItems[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueSupplementaryView(
            view: AppCollectionViewHeader.self,
            forSupplementaryViewOfKind: kind,
            indexPath: indexPath
        )
        headerView.configure(with: settings[indexPath.section].title)
        return headerView
    }
}

// MARK: - UICollectionViewDelegate

extension NewTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (collectionView.indexPathsForSelectedItems ?? [])
            .filter({ $0.section == indexPath.section && $0.item != indexPath.item && $0.row != indexPath.row })
            .forEach({ collectionView.deselectItem(at: $0, animated: false) })
        switch settings[indexPath.section] {
        case .emoji(let emojiItems):
            selectedEmoji = emojiItems[indexPath.item]
        case .color(let colorItems):
            selectedColor = colorItems[indexPath.item]
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: 50
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 24,
            right: 0
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: 52,
            height: 52
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - Setting Constraints

extension NewTrackerViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            buttonsStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
    }
}


