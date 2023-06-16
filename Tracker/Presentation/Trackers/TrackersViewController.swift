import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var placeholderView = AppPlaceholderView(
        with: UIImage(named: "icon-empty-tracker-list"),
        and: "Что будем отслеживать?"
    )
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.calendar.firstWeekday = 2
        datePicker.tintColor = .appBlue
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.reuseIdentifier
        )
        collectionView.register(
            AppCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AppCollectionViewHeader.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Data Source
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(
            name: "Домашние дела",
            trackers: [
                Tracker(name: "Поливать цветы", color: .colorSelection11, emoji: "🌼", schedule: [.monday, .thursday]),
                Tracker(name: "Съедать яблоко", color: .colorSelection4, emoji: "🍎", schedule: [.wednesday]),
                Tracker(name: "Готовить ужин по рецепту", color: .colorSelection18, emoji: "🥘", schedule: [.monday, .wednesday, .friday]),
                Tracker(name: "Прикинуться алладином", color: .colorSelection2, emoji: "🧞‍♂️", schedule: [.monday]),
                Tracker(name: "Вязать кофту", color: .colorSelection17, emoji: "🧶", schedule: [.wednesday]),
                Tracker(name: "Слепить снеговика", color: .colorSelection8, emoji: "⛄️", schedule: [.friday])
            ]
        ),
        TrackerCategory(
            name: "По работе",
            trackers: [
                Tracker(name: "Отправлять отчет", color: .colorSelection13, emoji: "✉️", schedule: [.monday]),
                Tracker(name: "Провести оперативку", color: .colorSelection16, emoji: "🥷🏻", schedule: [.wednesday]),
                Tracker(name: "Поплакать", color: .colorSelection1, emoji: "😭", schedule: [.friday])
            ]
        )
    ]
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
        setupNavigationBar()
        setDelegates()
        dateChanged()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .appWhite
        view.addSubview(placeholderView)
        view.addSubview(trackersCollectionView)
    }
    
    private func isEmptyVisibleCategories() {
        visibleCategories.isEmpty ? showPlaceholder() : showCollectionView()
    }
    
    private func showPlaceholder() {
        placeholderView.isHidden = false
        trackersCollectionView.isHidden = true
        navigationItem.searchController = nil
    }
    
    private func showCollectionView() {
        placeholderView.isHidden = true
        trackersCollectionView.isHidden = false
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "Поиск"
        navigationItem.searchController?.searchBar.delegate = self
    }
    
    // MARK: - Setup NavBar
    
    private func setupNavigationBar() {
        title = "Трекеры"
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
        UIBarButtonItem(customView: datePicker)
    }
    
    @objc
    private func addButtonTapped() {
        let creatingTrackerViewController = CreatingTrackerViewController()
        present(creatingTrackerViewController, animated: true)
    }
    
    private func setDelegates() {
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
    }
    
    @objc
    private func dateChanged() {
        let weekDay = Calendar.current.component(.weekday, from: datePicker.date)
        visibleCategories = categories.compactMap {
            let trackers = $0.trackers.filter {
                $0.schedule?.contains { $0.numberValue == weekDay } == true
            }
            if trackers.isEmpty { return nil }
            return TrackerCategory(name: $0.name, trackers: trackers)
        }
        isEmptyVisibleCategories()
        trackersCollectionView.reloadData()
    }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        if datePicker.date < Date() {
            let trackerRecord = TrackerRecord(taskId: id, executionDate: datePicker.date)
            completedTrackers.insert(trackerRecord)
            trackersCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        guard let trackerRecord = completedTrackers.filter({
            let isSameDay = Calendar.current.isDate($0.executionDate, inSameDayAs: datePicker.date)
            return $0.taskId == id && isSameDay
        }).first else { return }
        completedTrackers.remove(trackerRecord)
        trackersCollectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            dateChanged()
            trackersCollectionView.reloadData()
        } else {
            visibleCategories = visibleCategories.compactMap {
                let trackers = $0.trackers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                if trackers.isEmpty { return nil }
                return TrackerCategory(name: $0.name, trackers: trackers)
            }
            trackersCollectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dateChanged()
        trackersCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCell.reuseIdentifier,
                for: indexPath
            ) as? TrackerCell
        else {
            return UICollectionViewCell()
        }
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCompletedToday = isTrackerCompletedToday(id: currentTracker.id)
        let completedDays = completedTrackers.filter { $0.taskId == currentTracker.id }.count
        cell.delegate = self
        cell.configure(
            with: currentTracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: AppCollectionViewHeader.reuseIdentifier,
                for: indexPath
            ) as? AppCollectionViewHeader
        else {
            return UICollectionReusableView()
        }
        view.configure(with: visibleCategories[indexPath.section].name)
        return view
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains {
            let isSameDay = Calendar.current.isDate($0.executionDate, inSameDayAs: datePicker.date)
            return $0.taskId == id && isSameDay
        }
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 32 - 8) / 2, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 50)
    }
}


// MARK: - Setting Constraints

extension TrackersViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

