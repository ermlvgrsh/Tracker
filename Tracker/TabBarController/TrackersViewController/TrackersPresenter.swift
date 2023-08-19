import UIKit


final class TrackerPresenter {
    
    private weak var trackersView: TrackerViewProtocol? = nil
    let currentDate: Date = Date()
    var valueDatePicker: Date = Date()
    private let trackerService = TrackerService.shared
    private let analyticsService = AnalyticsService.shared
    
    
    init(trackerView: TrackerViewProtocol) {
        self.trackersView = trackerView
    }
    
    func viewDidLoad() {
        analyticsService.screenEventDidShowed()
    }
    
    func viewDidDisappear() {
        analyticsService.screenEventDidDisappear()
    }
    
    func addNewTracker() {
        analyticsService.screenAddNewTracker()
    }
    
    func showCurrentTrackers() {
        let selectedDay = Calendar.current.component(.weekday, from: valueDatePicker)
        let filterTrackers = trackerService.filterTrackersByWeekDay(selectedDay)
        
        if filterTrackers.isEmpty {
            trackersView?.showPlaceholer()
            return
        }
        let resultTracker = pinnedTrackers(currentTrackers: filterTrackers)
        trackersView?.showCurrentTrackers(categories: resultTracker)
        
    }
    
    func searchTrackersByName(name: String) {
        let selectedDay = Calendar.current.component(.weekday, from: valueDatePicker)
        guard let selectedDayEnum = WeekDay(rawValue: selectedDay) else { return }
        let searchName = name.lowercased()
        let searchedTrackers = trackerService.filterTrackers { tracker in
            tracker.schedule?.contains(selectedDayEnum) ?? true && tracker.name.lowercased().contains(searchName)
        }
        if searchedTrackers.isEmpty {
            trackersView?.showNoFoundPlaceholder()
            return
        }
        trackersView?.showCurrentTrackers(categories: searchedTrackers)
    }
    
    func updateDatePicker(date: Date) {
        valueDatePicker = date
        
    }
    
    func pinTracker(trackerID: UUID) {
        guard let tracker = trackerService.getTracker(trackerID: trackerID),
              !tracker.isPinned else { return }
        trackerService.pinTracker(tracker: tracker)
    }
    
    func unPinTracker(trackerID: UUID) {
        guard let tracker = trackerService.getTracker(trackerID: trackerID),
              tracker.isPinned else { return }
        trackerService.unpinTracker(tracker: tracker)
    }
    
    func editTracker(trackerID: UUID) {
        analyticsService.sendEditTrackerEvent()
        guard let trackerInfo = trackerService.getTrackerInfo(trackerID: trackerID) else { return }
        let trackersFlowView = TrackerFlowView(flow: TrackerFlow.edit, trackerInfo: trackerInfo)
        
        trackersView?.editTracker(trackerDetails: trackersFlowView)
    }
    private func formattedDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func handleTapOnTracker(for cell: TrackersViewCell, tracker: Tracker) {
        analyticsService.sendTrackerTapEvent()
        
        let calendar = Calendar.current
        guard let valueDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: valueDatePicker)) else { return }
        let today = formattedDateToString(date: currentDate)
        let datePicker = formattedDateToString(date: valueDatePicker)
        let isAlreadyMarked = trackerService.completedTrackers.contains { record in
            record.id == tracker.id && valueDate == record.date
        }
        if !isAlreadyMarked {
            guard today >= datePicker else { return }
            let updatedTracker = Tracker(id: tracker.id, name: tracker.name, schedule: tracker.schedule, color: tracker.color, emoji: tracker.emoji, isPinned: tracker.isPinned, dayCounter: tracker.dayCounter + 1)
            trackerService.addTrackerRecord(trackerRecord: TrackerRecord(id: tracker.id, date: valueDate))
            trackerService.updateTracker(tracker: updatedTracker)
            cell.animateButtonWithTransition(previousButton: cell.plusButton, to: cell.doneButton) {
                cell.daysCounter.text = updatedTracker.dayCounter.dayToString()
                cell.backgroundViewDone.alpha = 0.3
                cell.backgroundViewDone.isHidden = false
            }
        } else {
            let updateTracker = Tracker(id: tracker.id, name: tracker.name, schedule: tracker.schedule, color: tracker.color, emoji: tracker.emoji, isPinned: tracker.isPinned, dayCounter: max(tracker.dayCounter - 1, 0))
            trackerService.updateTracker(tracker: updateTracker)
            trackerService.deleteTrackerRecord(trackerRecord: TrackerRecord(id: tracker.id, date: valueDate))
            cell.animateButtonWithTransition(previousButton: cell.doneButton, to: cell.plusButton) {
                cell.daysCounter.text = updateTracker.dayCounter.dayToString()
                cell.backgroundViewDone.isHidden = true
            }
        }
        
    }
    
    func onBindTrackerCell(cell: TrackersViewCell, tracker: Tracker) {
        let isTrackerDoneToday = trackerService.completedTrackers.filter {$0.id == tracker.id && $0.date == valueDatePicker }.count > 0
        let counter = trackerService.completedTrackers.filter {$0.id == tracker.id }.count
        let trackerView = TrackerView(id: tracker.id,
                                      trackerName: tracker.name,
                                      color: tracker.color,
                                      emoji: tracker.emoji,
                                      isPinned: tracker.isPinned,
                                      dayCounter: counter.dayToString(),
                                      isDoneToday: isTrackerDoneToday)
        if tracker.isPinned == true {
            cell.pinnedImage.isHidden = false
        } else {
            cell.pinnedImage.isHidden = true
        }
        trackersView?.bindTrackerViewCell(cell: cell, trackerView: trackerView)
    }
    
    func pinnedTrackers(currentTrackers: [TrackerCategory]) -> [TrackerCategory] {
        var pinnedTrackers = [Tracker]()
        var unpinnedCategory = [TrackerCategory]()
        
        for category in currentTrackers {
            let (pinnedTrackerInCategory, unpinnedTrackers) = category.trackers.partioned(by: { $0.isPinned })
            if !pinnedTrackerInCategory.isEmpty {
                pinnedTrackers.append(contentsOf: pinnedTrackerInCategory)
            }
            if !unpinnedTrackers.isEmpty {
                unpinnedCategory.append(TrackerCategory(categoryName: category.categoryName, trackers: unpinnedTrackers))
            }
        }
        if pinnedTrackers.isEmpty {
            return unpinnedCategory
        }
        let pinnedCategory = TrackerCategory(categoryName: "pinned".localized, trackers: pinnedTrackers)
        let result = [pinnedCategory] + unpinnedCategory
        return result
    }
    
    func updateStateButton(for cell: TrackersViewCell, tracker: Tracker?) {
        
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
    
    private func isTrackerCompletedOnDate(tracker: Tracker, date: String) -> Bool {
        return trackerService.completedTrackers.contains {$0.id == tracker.id && formattedDateToString(date: $0.date) == date }
    }
}
