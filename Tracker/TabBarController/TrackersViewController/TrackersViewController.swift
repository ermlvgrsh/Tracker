import UIKit

protocol TrackerViewProtocol: AnyObject {
    func showPlaceholer()
    func showNoFoundPlaceholder()
    func showCurrentTrackers(categories: [TrackerCategory])
    func bindTrackerViewCell(cell: TrackersViewCell, trackerView: TrackerView)
    func editTracker(trackerDetails: TrackerFlowView
    )
}


final class TrackersViewController: UIViewController {
    
    var currentDate = Date()

    var valueDatePicker: Date = Date()  {
        didSet {
            
        }
    }
    private var searchText: String = ""
    private var presenter: TrackerPresenter?
    private let analyticService = AnalyticsService.shared
    var cateigories: [TrackerCategory] = []
    var visibleTrackersCategory: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []
    private let trackerService: TrackerService
    let darkMode = DarkMode()
    private lazy var datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.locale = dateFormatter.locale
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueDidChanged), for: .valueChanged)
        return datePicker
    }()

    private lazy var addButton: UIBarButtonItem = {
       let button = UIBarButtonItem(image: UIImage(named: "plus"),
                                    style: .plain,
                                    target: self,
                                    action: #selector(addTracker))
        button.tintColor = darkMode.tintAddButtonColor
        return button
    }()
    
    init(trackerService: TrackerService) {
        self.trackerService = trackerService
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: TrackersViewCell.identifier)
        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryView.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 0.906, alpha: 1).cgColor
        
        button.layer.masksToBounds = true
        let titleAttibuted: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17, weight: .regular)
        ]
        let titleAttributedString = NSAttributedString(string: "filters".localized,
                                                       attributes: titleAttibuted)
        button.setAttributedTitle(titleAttributedString, for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    @objc func filterButtonTapped() {
       let filterTrackerVC = FilterTrackerViewController()
        analyticService.sendTrackerFilterEvent()
        present(filterTrackerVC, animated: true)
    }
    
    private let placeholderImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let errorImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "2"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        paragraphStyle.alignment = .center
        label.attributedText =
        NSMutableAttributedString(string: "nothing_to_found".localized, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        paragraphStyle.alignment = .center
        label.attributedText =
        NSMutableAttributedString(string: "what_to_track".localized, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "trackers".localized
        trackerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerLabel.tintColor = .label
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
   private lazy var searchBar: UISearchTextField = {
        let searchBar = UISearchTextField()
        searchBar.placeholder = "search".localized
        searchBar.layer.masksToBounds = true
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("cancel".localized, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        searchBar.rightView = cancelButton
        searchBar.rightViewMode = .whileEditing
        searchBar.translatesAutoresizingMaskIntoConstraints = false
       searchBar.backgroundColor = .systemBackground
        searchBar.layer.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12).cgColor
        searchBar.layer.cornerRadius = 8
        return searchBar
    }()
    
    @objc func cancelButtonTapped() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintsForTrackerView()
        presenter = TrackerPresenter(trackerView: self)
        presenter?.viewDidLoad()
        applyConditionAndShowTrackers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter?.viewDidDisappear()
    }
    
    @objc func addTracker() {
        let trackerCreator = TrackerCreatorViewController()
        trackerCreator.delegate = self
        self.present(trackerCreator, animated: true)
        
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private lazy var datePickerToolItem: UIBarButtonItem = {
       let toolItem = UIBarButtonItem(customView: datePicker)
        return toolItem
    }()
    
    private func constraintsForTrackerView() {
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = datePickerToolItem
        view.addSubview(collectionView)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        view.addSubview(searchBar)
        view.addSubview(trackerLabel)
        view.addSubview(errorImage)
        view.addSubview(errorLabel)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            trackerLabel.widthAnchor.constraint(equalToConstant: 254),
            trackerLabel.heightAnchor.constraint(equalToConstant: 41),

            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            placeholderImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -101),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            placeholderLabel.widthAnchor.constraint(equalToConstant: 343),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 18),
            
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.widthAnchor.constraint(equalToConstant: 343),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            errorImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorImage.widthAnchor.constraint(equalToConstant: 80),
            errorImage.heightAnchor.constraint(equalToConstant: 80),
            
            errorLabel.centerXAnchor.constraint(equalTo: errorImage.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 8),
            errorLabel.widthAnchor.constraint(equalToConstant: 343),
            errorLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        if !visibleTrackersCategory.isEmpty {
            presenter?.showCurrentTrackers()
        }
        
    }
    
    private func applyConditionAndShowTrackers() {
        if searchText.isEmpty {
            presenter?.showCurrentTrackers()
            configureCollectionView()
            return
        }
        presenter?.searchTrackersByName(name: searchText)
    }
    
    private func hideErrors() {
        errorImage.isHidden = true
        errorLabel.isHidden = true
        placeholderImage.isHidden = true
        placeholderLabel.isHidden = true
        collectionView.isHidden = false
        filterButton.isHidden = false
        collectionView.reloadData()
    }

    
    private func formattedDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    @objc func datePickerValueDidChanged(_ sender: UIDatePicker) {
        presenter?.updateDatePicker(date: sender.date)
    }
    
    private func isTrackerCompletedOnDate(tracker: Tracker, date: String) -> Bool {
        return trackerService.completedTrackers.contains {$0.id == tracker.id && formattedDateToString(date: $0.date) == date }
    }
    
    private func showDeleteTrackerAlert(tracker: Tracker?) {
        let alertController = UIAlertController(title: "confirm_delete_tracker".localized, message: nil, preferredStyle: .actionSheet)
        let removeAction = UIAlertAction(title: "delete".localized,
                                         style: .destructive) { [weak self] _ in
            if let tracker = tracker {
                self?.trackerService.removeTracker(tracker: tracker)
                self?.analyticService.sendTrackerDeleteEvent()
                self?.applyConditionAndShowTrackers()
            }
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

  private func updateStateButton(for cell: TrackersViewCell, tracker: Tracker?) {
        
        let datePicker = formattedDateToString(date: valueDatePicker)
        
        let isTrackerCompleted: Bool
        
        if let tracker = tracker {
            isTrackerCompleted = isTrackerCompletedOnDate(tracker: tracker, date: datePicker)
            
        } else {
            isTrackerCompleted = false
        }
        
        if isTrackerCompleted {
            cell.animateButtonWithTransition(previousButton: cell.plusButton, to: cell.doneButton) {

                cell.backgroundViewDone.alpha = 0.3
                cell.backgroundViewDone.isHidden = false
            }
        } else {
            cell.animateButtonWithTransition(previousButton: cell.doneButton, to: cell.plusButton) {
                cell.backgroundViewDone.isHidden = true
            }
        }
    }
}

extension TrackersViewController: TrackerViewProtocol {
    func showPlaceholer() {
        placeholderImage.isHidden = false
        placeholderLabel.isHidden = false
        collectionView.isHidden = true
        filterButton.isHidden = true
    }
    
    func showNoFoundPlaceholder() {
        errorImage.isHidden = false
        errorLabel.isHidden = false
        collectionView.isHidden = true
        filterButton.isHidden = true
    }
    
    func showCurrentTrackers(categories: [TrackerCategory]) {
        collectionView.isHidden = false
        filterButton.isHidden = false
        errorImage.isHidden = true
        errorLabel.isHidden = true
        placeholderImage.isHidden = true
        placeholderLabel.isHidden = true
        self.visibleTrackersCategory = categories
        collectionView.reloadData()
    }
    
    func bindTrackerViewCell(cell: TrackersViewCell, trackerView: TrackerView) {
        cell.bindCell(tracker: trackerView)
        cell.delegate = self
    }
    

    func editTracker(trackerDetails: TrackerFlowView) {
        let newHabbitVC = NewHabbitViewController()
        newHabbitVC.selectedFlow = trackerDetails
        newHabbitVC.selectedTrackerType = trackerDetails.trackerInfo.type
        newHabbitVC.delegate = self
        present(newHabbitVC, animated: true)
    }
    
    
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleTrackersCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleTrackersCategory[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersViewCell.identifier, for: indexPath) as? TrackersViewCell else { fatalError("Unable to dequeue TrackersViewCell") }
        
        let visibleTracker = visibleTrackersCategory[indexPath.section].trackers[indexPath.row]
        presenter?.onBindTrackerCell(cell: cell, tracker: visibleTracker)
        updateStateButton(for: cell, tracker: visibleTracker)
        
        return cell
    }
    
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader: id = "header"
        case UICollectionView.elementKindSectionFooter: id = "footer"
        default: id = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerSupplementaryView else { return UICollectionReusableView() }
        let category = visibleTrackersCategory[indexPath.section]
        view.categoryLabel.text = category.categoryName
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 41) / 2
        let height = width * 0.8
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return nil }
            
            let currentTracker = self.visibleTrackersCategory[indexPath.section].trackers[indexPath.row]
            let pinOrUnpinAction: UIAction
            if currentTracker.isPinned {
                pinOrUnpinAction = UIAction(title: "unpin".localized) { [weak self] _ in
                    guard let self else { return }
                    self.presenter?.unPinTracker(trackerID: currentTracker.id)
                    self.applyConditionAndShowTrackers()
                }
            } else {
                pinOrUnpinAction = UIAction(title: "pin".localized) {
                    [weak self] _ in
                    guard let self else { return }
                    self.presenter?.pinTracker(trackerID: currentTracker.id)
                    self.applyConditionAndShowTrackers()
                }
            }
            let editAction = UIAction(title: "edit".localized) {
                [weak self] _ in
                guard let self else { return }
                self.presenter?.editTracker(trackerID: currentTracker.id)
            }
            let removeAction = UIAction(title: "delete".localized, attributes: .destructive) {
                [weak self] _ in
                self?.showDeleteTrackerAlert(tracker: currentTracker)
                
            }
            return UIMenu(children: [pinOrUnpinAction, editAction, removeAction])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}

extension TrackersViewController: UISearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButtonToKeyboard()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        presenter?.searchTrackersByName(name: searchText)
        if searchText.isEmpty {
            applyConditionAndShowTrackers()
        }
        collectionView.reloadData()
    }
}

extension TrackersViewController: NewTrackerDelegate {
    func didUpdateTracker(tracker: Tracker, with category: TrackerCategory) {
        hideErrors()
        configureCollectionView()
        collectionView.reloadData()
        presenter?.showCurrentTrackers()
    }
    
    func didCreateTracker(newTracker: Tracker, with category: TrackerCategory) {
        placeholderImage.isHidden = true
        placeholderLabel.isHidden = true
        
        trackerService.addNewTracker(tracker: newTracker, trackerCategory: category.categoryName)
        configureCollectionView()
        collectionView.reloadData()
        presenter?.showCurrentTrackers()
    }
}

extension TrackersViewController: TrackerViewCellDelegate {
    
    func doneButtonUntapped(for cell: TrackersViewCell) {
        
        let calendar = Calendar.current
        guard let valueDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: valueDatePicker)) else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let trackerIndex = indexPath.row
        let categoryIndex = indexPath.section
        let category = visibleTrackersCategory[categoryIndex]
        let trackers = category.trackers
        let tracker = trackers[trackerIndex]
        
        if trackerService.completedTrackers.contains(where: { $0.id == tracker.id && formattedDateToString(date:  $0.date) == formattedDateToString(date: valueDatePicker) }) {
            let updateTracker = Tracker(id: tracker.id, name: tracker.name, schedule: tracker.schedule, color: tracker.color, emoji: tracker.emoji, isPinned: false, dayCounter: max(tracker.dayCounter - 1, 0))
            trackerService.updateTracker(tracker: updateTracker)
            analyticService.sendTrackerTapEvent()
            trackerService.deleteTrackerRecord(trackerRecord: TrackerRecord(id: updateTracker.id, date: valueDate))
            
            cell.animateButtonWithTransition(previousButton: cell.doneButton, to: cell.plusButton) {
                cell.daysCounter.text = updateTracker.dayCounter.dayToString()
                cell.backgroundViewDone.isHidden = true
            }
        }
    }
    
    func doneButtonDidTapped(for cell: TrackersViewCell) {
        let calendar = Calendar.current
        guard let valueDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: valueDatePicker)) else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let today = formattedDateToString(date: currentDate)
        let datePicker = formattedDateToString(date: valueDatePicker)
        
        let trackerIndex = indexPath.row
        let categoryIndex = indexPath.section
        
        let category = visibleTrackersCategory[categoryIndex]
        let trackers = category.trackers
        let tracker = trackers[trackerIndex]
        
        if today >= datePicker {
            let updatedTracker = Tracker(id: tracker.id, name: tracker.name, schedule: tracker.schedule, color: tracker.color, emoji: tracker.emoji, isPinned: tracker.isPinned, dayCounter: tracker.dayCounter + 1)
            
            let newRecord = TrackerRecord(id: updatedTracker.id, date: valueDate)
            trackerService.updateTracker(tracker: updatedTracker)
            trackerService.addTrackerRecord(trackerRecord: newRecord)
            analyticService.sendTrackerTapEvent()
            
            cell.animateButtonWithTransition(previousButton: cell.plusButton, to: cell.doneButton) {
                cell.daysCounter.text = updatedTracker.dayCounter.dayToString()
                cell.backgroundViewDone.alpha = 0.3
                cell.backgroundViewDone.isHidden = false
            }
        }
    }
}
