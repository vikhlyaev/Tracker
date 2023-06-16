import UIKit

final class NewHabitViewController: UIViewController {
    
    // MARK: - Sections
    
    private enum SettingsTableViewSection: Int, CaseIterable {
        case category
        case schedule
        
        var title: String {
            switch self {
            case .category:
                return "Категория"
            case .schedule:
                return "Расписание"
            }
        }
    }
    
    private enum SettingsCollectionViewSection {
        case emoji([String])
        case color([UIColor])
        
        var title: String {
            switch self {
            case .emoji:
                return "Emoji"
            case .color:
                return "Цвет"
            }
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLabel = AppTitleLabel(with: "Новая привычка")
    
    private lazy var trackerNameTextField = AppTextField(with: "Введите название трекера")
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = .appGray
        tableView.bounces = false
        tableView.registerReusableCell(cellType: SettingsCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var settingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    private lazy var createButton = AppButton(title: "Создать") {
        print("createButton")
    }
    
    private lazy var cancelButton = AppButton(title: "Отменить", style: .cancel) { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let settings: [SettingsCollectionViewSection] = [
        .emoji(["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]),
        .color([.colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18])
    ]
    
    private var selectedDays: Set<WeekDay> = []
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    
    // MARK: - Life Cycle
    
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
        scrollView.addSubview(trackerNameTextField)
        scrollView.addSubview(settingsTableView)
        scrollView.addSubview(settingsCollectionView)
        scrollView.addSubview(buttonsStackView)
    }
    
    private func setDelegates() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingsTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: SettingsCell.self)
        cell.configure(with: SettingsTableViewSection.allCases[indexPath.row].title)
        cell.tag = indexPath.row
        return cell
    }
}

// MARK: - UITableViewDelegate

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsCell else { return }
        switch cell.tag {
        case 0:
            let categoryViewController = CategoryViewController()
            present(categoryViewController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController(with: selectedDays)
            scheduleViewController.delegate = self
            present(scheduleViewController, animated: true)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if indexPath.row == SettingsTableViewSection.allCases.count - 1 {
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UICollectionViewDataSource

extension NewHabitViewController: UICollectionViewDataSource {
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

extension NewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filteredItems = (collectionView.indexPathsForSelectedItems ?? []).filter {
            $0.section == indexPath.section && $0.item != indexPath.item && $0.row != indexPath.row
        }
        filteredItems.forEach { collectionView.deselectItem(at: $0, animated: false) }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - ScheduleDelegate

extension NewHabitViewController: ScheduleDelegate {
    func didSelectDays(_ days: Set<WeekDay>) {
        selectedDays = days
        updateScheduleCell(days: Array(days))
    }
    
    private func updateScheduleCell(days: [WeekDay]) {
        let selectedSettings = days
            .sorted(by: { $0.rawValue < $1.rawValue })
            .map { $0.shortTitle }
            .joined(separator: ", ")
        let scheduleCell = settingsTableView.visibleCells.filter({
            $0.tag == SettingsTableViewSection.schedule.rawValue
        }).first as? SettingsCell
        scheduleCell?.updateSelectedSettings(selectedSettings)
    }
}

// MARK: - Setting Constraints

extension NewHabitViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            trackerNameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            settingsTableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsTableView.heightAnchor.constraint(equalToConstant: 150),
            
            settingsCollectionView.topAnchor.constraint(equalTo: settingsTableView.bottomAnchor, constant: 24),
            settingsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            settingsCollectionView.heightAnchor.constraint(equalToConstant: 460),
            
            buttonsStackView.topAnchor.constraint(equalTo: settingsCollectionView.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
        ])
    }
}

