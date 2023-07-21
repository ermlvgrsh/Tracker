import UIKit

final class TrackersViewController: UIViewController {
    
    var currentDate = Date()

    var valueDatePicker: Date = Date()  {
        didSet {
            updateTrackers()
        }
    }
    
    var trackers: [Tracker] = []
    var visibleTrackersCategory: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []
    
    var visibleIrregularCategories: [IrregularEventCategory] = []
    var completedEvents: Set<IrregularEventRecord> = []
    private let trackerService: TrackerService
    private let eventService: IrregularEventService
    private var datePicker: UIDatePicker?
    private var datePickerView: UIView?
    private var addButtonView: UIView?
    
    init(trackerService: TrackerService, eventService: IrregularEventService) {
        self.trackerService = trackerService
        self.eventService = eventService
        super.init(nibName: nil, bundle: nil)
    }
    
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
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        paragraphStyle.alignment = .center
        label.attributedText =
        NSMutableAttributedString(string: "Ничего не найдено", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        paragraphStyle.alignment = .center
        label.attributedText =
        NSMutableAttributedString(string: "Что будем отслеживать?", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "Трекеры"
        trackerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerLabel.tintColor = .black
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    lazy var searchBar: UISearchTextField = {
        let searchBar = UISearchTextField()
        searchBar.placeholder = "Поиск"
        searchBar.layer.masksToBounds = true
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        searchBar.rightView = cancelButton
        searchBar.rightViewMode = .whileEditing
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
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
    }
    
    @objc func addTracker() {
        let trackerCreator = TrackerCreatorViewController()
        trackerCreator.delegate = self
        trackerCreator.irregularDelegate = self
        self.present(trackerCreator, animated: true)
        
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureAddButton() -> UIBarButtonItem? {
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        addButton.tintColor = .black
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        addButtonView = view
        addButtonView?.translatesAutoresizingMaskIntoConstraints = false
        addButtonView?.addSubview(addButton)
        guard let addButtonView = addButtonView else { return nil }
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: addButtonView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: addButtonView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: addButtonView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: addButtonView.bottomAnchor),
        ])
        let buttonItem = UIBarButtonItem(customView: addButtonView)
        return buttonItem
    }
    
    private func configureDatePicker() -> UIBarButtonItem? {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueDidChanged), for: .valueChanged)
        self.datePicker = datePicker
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 77, height: 34))
        datePickerView = view
        guard let datePickerView = datePickerView else { return nil }
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerView.bottomAnchor),
        ])
        
        let dateItem = UIBarButtonItem(customView: datePickerView)
        return dateItem
    }
    
    private func constraintsForTrackerView() {
        view.backgroundColor = .white
        searchBar.delegate = self
        
        let buttonItem = configureAddButton()
        let dateItem = configureDatePicker()
        
        navigationItem.leftBarButtonItem = buttonItem
        navigationItem.rightBarButtonItem = dateItem
        
        guard let datePickerView = datePickerView,
              let addButtonView = addButtonView else { return }
        
        view.addSubview(datePickerView)
        view.addSubview(addButtonView)
        view.addSubview(collectionView)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        view.addSubview(searchBar)
        view.addSubview(trackerLabel)
        view.addSubview(errorImage)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            
            datePickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 91),
            datePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 282),
            datePickerView.heightAnchor.constraint(equalToConstant: 34),
            datePickerView.widthAnchor.constraint(equalToConstant: 77),
            
            addButtonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            addButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            addButtonView.heightAnchor.constraint(equalToConstant: 18),
            addButtonView.widthAnchor.constraint(equalToConstant: 18),
            
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
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            placeholderLabel.widthAnchor.constraint(equalToConstant: 343),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 18),
            
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
        if !trackerService.categories.isEmpty || !eventService.eventCategories.isEmpty {
            updateTrackers()
        }
        
    }
    private func showErrors() {
        errorImage.isHidden = false
        errorLabel.isHidden = false
        collectionView.isHidden = true
    }
    
    private func hideErrors() {
        errorImage.isHidden = true
        errorLabel.isHidden = true
        placeholderImage.isHidden = true
        placeholderLabel.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    
    private func formattedDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    @objc func datePickerValueDidChanged(_ sender: UIDatePicker) {
        valueDatePicker = sender.date
        updateTrackers()
    }
 
    private func updateTrackers() {
        
        let selectedDay = Calendar.current.component(.weekday, from: valueDatePicker)
        trackerService.filteredTrackers = trackerService.filterTrackersByWeekDay(selectedDay)
        eventService.filteredEvents = eventService.eventCategories
        if trackerService.filteredTrackers.isEmpty && eventService.filteredEvents.isEmpty {
            showErrors()
            placeholderImage.isHidden = true
            placeholderLabel.isHidden = true
        } else {
            hideErrors()
            configureCollectionView()
        }
    }
    
    private func isTrackerCompletedOnDate(tracker: Tracker, date: String) -> Bool {
        return trackerService.completedTrackers.contains {$0.id == tracker.id && formattedDateToString(date: $0.date) == date }
    }
    private func isEventCompletedOnDate(event: IrregularEvent, date: String) -> Bool {
        return eventService.completedEvents.contains {$0.id == event.id && formattedDateToString(date: $0.date) == date}
    }
    

  private func updateStateButton(for cell: TrackersViewCell, tracker: Tracker?, event: IrregularEvent?) {
        
        let datePicker = formattedDateToString(date: valueDatePicker)
        
        let isTrackerCompleted: Bool
        let isEventCompleted: Bool
        
        if let tracker = tracker {
            isTrackerCompleted = isTrackerCompletedOnDate(tracker: tracker, date: datePicker)
            
            isEventCompleted = false
        } else if let event = event {
            isTrackerCompleted = false
            isEventCompleted = isEventCompletedOnDate(event: event, date: datePicker)
        } else {
            isTrackerCompleted = false
            isEventCompleted = false
        }
        
        if isTrackerCompleted || isEventCompleted {
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

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let trackerSection = trackerService.filteredTrackers.count
        let eventSection = eventService.filteredEvents.count
        return trackerSection + eventSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let isTrackerSection = section < trackerService.filteredTrackers.count

        if isTrackerSection {
            return trackerService.filteredTrackers[section].trackers.count
        } else {
            let eventSectionIndex = section - trackerService.filteredTrackers.count
            guard eventSectionIndex >= 0 && eventSectionIndex < eventService.filteredEvents.count else { return 0 }
            return eventService.eventCategories[eventSectionIndex].irregularEvents.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isTrackerSection = indexPath.section < trackerService.filteredTrackers.count
        if isTrackerSection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersViewCell.identifier, for: indexPath) as? TrackersViewCell else { fatalError("Unable to dequeue TrackersViewCell") }
            
            let visibleTracker = trackerService.filteredTrackers[indexPath.section].trackers[indexPath.row]
                cell.delegate = self
                cell.configureCell(with: visibleTracker.name, color: visibleTracker.color, emoji: visibleTracker.emoji, dayCounter: visibleTracker.dayCounter)
                updateStateButton(for: cell, tracker: visibleTracker, event: nil)
            
            return cell
        } else {
            let irregularSectionIndex = indexPath.section - trackerService.filteredTrackers.count
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersViewCell.identifier, for: indexPath) as? TrackersViewCell else { fatalError("Unable to dequeue Event") }
            let visibleEvent = eventService.filteredEvents[irregularSectionIndex].irregularEvents[indexPath.row]
            cell.delegate = self
            cell.configureCell(with: visibleEvent.name, color: visibleEvent.color, emoji: visibleEvent.emoji, dayCounter: visibleEvent.dayCounter)
            updateStateButton(for: cell, tracker: nil, event: visibleEvent)
            return cell
        }
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
        let trackerCount = trackerService.filteredTrackers.count
        let isTrackerSection = indexPath.section < trackerCount
        if isTrackerSection {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerSupplementaryView else { return UICollectionReusableView() }
            guard indexPath.section < trackerCount else { return view }
            let category = trackerService.fetchCategory(at: indexPath.section)
            view.categoryLabel.text = category
            return view
        } else {
            let irregularIndexSection = indexPath.section - trackerCount
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerSupplementaryView else { return UICollectionReusableView() }
            guard irregularIndexSection < eventService.filteredEvents.count else { return view }
            let event = eventService.fetchEventCategory(at: irregularIndexSection)
            view.categoryLabel.text = event
            return view
        }
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
        
        if searchText.isEmpty {
            trackerService.filteredTrackers = trackerService.categories
            eventService.filteredEvents = eventService.eventCategories
            collectionView.isHidden = false
            hideErrors()
        } else {
            trackerService.filteredTrackers = trackerService.filterTrackers { tracker in
                return tracker.name.localizedStandardContains(searchText)
            }
            eventService.filteredEvents = eventService.filterEvents { event in
                return event.name.localizedStandardContains(searchText)
            }
            
            if trackerService.filteredTrackers.isEmpty && eventService.filteredEvents.isEmpty {
                showErrors()
            } else {
                hideErrors()
            }
        }
        
        collectionView.reloadData()
    }
}

extension TrackersViewController: NewTrackerDelegate {
    func didCreateTracker(newTracker: Tracker, with category: TrackerCategory) {
        placeholderImage.isHidden = true
        placeholderLabel.isHidden = true
        
        trackerService.addNewTracker(tracker: newTracker, trackerCategory: category)
        configureCollectionView()
        collectionView.reloadData()
        updateTrackers()
    }
}

extension TrackersViewController: IrregularEventDelegate {
    func didCreateIrregularEvent(newEvent: IrregularEvent, with category: IrregularEventCategory) {
        placeholderImage.isHidden = true
        placeholderLabel.isHidden = true
        
        eventService.addNewEvent(event: newEvent, eventCategory: category)
        configureCollectionView()
        collectionView.reloadData()
        updateTrackers()
    }
}
extension TrackersViewController: TrackerViewCellDelegate {

func doneButtonUntapped(for cell: TrackersViewCell) {

    let calendar = Calendar.current
    guard let valueDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: valueDatePicker)) else { return }
      guard let indexPath = collectionView.indexPath(for: cell) else { return }
      
    let isTrackerSection = indexPath.section < trackerService.filteredTrackers.count
      if isTrackerSection {
          let trackerIndex = indexPath.row
          let categoryIndex = indexPath.section
          let category = trackerService.filteredTrackers[categoryIndex]
          let trackers = category.trackers
          let tracker = trackers[trackerIndex]
          
          if trackerService.completedTrackers.contains(where: { $0.id == tracker.id && formattedDateToString(date:  $0.date) == formattedDateToString(date: valueDatePicker) }) {
              let updateTracker = Tracker(id: tracker.id, name: tracker.name, schedule: tracker.schedule, color: tracker.color, emoji: tracker.emoji, dayCounter: max(tracker.dayCounter - 1, 0))
              trackerService.updateTracker(tracker: updateTracker)

              trackerService.deleteTrackerRecord(trackerRecord: TrackerRecord(id: updateTracker.id, date: valueDate))
              
              cell.animateButtonWithTransition(previousButton: cell.doneButton, to: cell.plusButton) {
                  cell.daysCounter.text = cell.updateDayCounterLabel(with: updateTracker.dayCounter)
                  cell.backgroundViewDone.isHidden = true
              }
          }
      } else {
          let eventIndexSection = indexPath.section - trackerService.filteredTrackers.count
          let eventIndex = indexPath.row
          let category = eventService.filteredEvents[eventIndexSection]
          let events = category.irregularEvents
          let event = events[eventIndex]
          
          if eventService.completedEvents.contains(where: { $0.id == event.id && formattedDateToString(date: $0.date) == formattedDateToString(date: valueDatePicker)}) {
              let updateEvent = IrregularEvent(id: event.id, name: event.name, emoji: event.emoji, color: event.color, dayCounter: event.dayCounter - 1)
              let deletedRecord = IrregularEventRecord(id: updateEvent.id, date: valueDate)
              eventService.updateEvent(event: updateEvent)
              eventService.deleteEventRecord(eventRecord: deletedRecord)
              cell.animateButtonWithTransition(previousButton: cell.doneButton, to: cell.plusButton) {
                  cell.daysCounter.text = cell.updateDayCounterLabel(with: updateEvent.dayCounter)
                  cell.backgroundViewDone.isHidden = true
                 
              }
          }
      }
  }

func doneButtonDidTapped(for cell: TrackersViewCell) {
    let calendar = Calendar.current
    guard let valueDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: valueDatePicker)) else { return }
       guard let indexPath = collectionView.indexPath(for: cell) else { return }
       
       let today = formattedDateToString(date: currentDate)
       let datePicker = formattedDateToString(date: valueDatePicker)
       
    let isTrackSection = indexPath.section < trackerService.filteredTrackers.count
       if isTrackSection {
           let trackerIndex = indexPath.row
           let categoryIndex = indexPath.section
           
           let category = trackerService.filteredTrackers[categoryIndex]
           let trackers = category.trackers
           let tracker = trackers[trackerIndex]

           if today >= datePicker {
               let updatedTracker = Tracker(id: tracker.id, name: tracker.name, schedule: tracker.schedule, color: tracker.color, emoji: tracker.emoji, dayCounter: tracker.dayCounter + 1)
               
               let newRecord = TrackerRecord(id: updatedTracker.id, date: valueDate)
               trackerService.updateTracker(tracker: updatedTracker)
               trackerService.addTrackerRecord(trackerRecord: newRecord)
               
               cell.animateButtonWithTransition(previousButton: cell.plusButton, to: cell.doneButton) {
                   cell.daysCounter.text = cell.updateDayCounterLabel(with: updatedTracker.dayCounter)
                   cell.backgroundViewDone.alpha = 0.3
                   cell.backgroundViewDone.isHidden = false
               }
           }
       } else {
           let eventIndexSection = indexPath.section - trackerService.filteredTrackers.count
           let categoryIndex = eventIndexSection
           let eventIndex = indexPath.row
           let category = eventService.filteredEvents[categoryIndex]
           let events = category.irregularEvents
           let event = events[eventIndex]
           if today >= datePicker {
               
               let updatedEvent = IrregularEvent(id: event.id, name: event.name, emoji: event.emoji, color: event.color, dayCounter: event.dayCounter + 1)

               let newRecord = IrregularEventRecord(id: updatedEvent.id, date: valueDate)
               eventService.updateEvent(event: event)
               eventService.addEventRecord(eventRecord: newRecord)

               cell.animateButtonWithTransition(previousButton: cell.plusButton, to: cell.doneButton) {
                   cell.daysCounter.text = cell.updateDayCounterLabel(with: updatedEvent.dayCounter)
                   cell.backgroundViewDone.alpha = 0.3
                   cell.backgroundViewDone.isHidden = false
               }
           }
       }
   }
}
