import UIKit

final class TrackerService {
    
    static let shared = TrackerService()
    static let changeContentNotification = Notification.Name(rawValue: "ChangeContentNotification")
    private let encoder = JSONEncoder()
    @Observable
    private(set) var categories: [TrackerCategory] = []
    
    @Observable
    private(set) var completedTrackers: Set<TrackerRecord> = []
    
    lazy var trackerStore: TrackerStore = {
        let trackerStore = TrackerStore(storeDelegate: self)
        return trackerStore
    }()
    
    private lazy var trackerCategoryStore: TrackerCategoryStore = {
        let trackerCategoryStore = TrackerCategoryStore(storeDelegate: self)
        return trackerCategoryStore
    }()
    
    lazy var trackerRecordStore: TrackerRecordStore = {
        let trackerRecordStore = TrackerRecordStore(storeDelegate: self)
        return trackerRecordStore
    }()
    
    func fetchCategory(at index: Int) -> String? {
        trackerCategoryStore.fetchCategory(at: index)
    }
    
    func fetchTracker(at indexPath: IndexPath) -> Tracker? {
        let trackerCore = trackerStore.resultsController.object(at: indexPath)
        return trackerCore.toTracker(decoder: JSONDecoder())
    }
    
    func addCategory(categoryName: String) {
        trackerCategoryStore.addCategory(trackerCategory: categoryName)
    }
    
    private init() {
        categories = trackerCategoryStore.categories
        completedTrackers = Set(trackerRecordStore.records)
    }
    
    func updateTracker(tracker: Tracker) {
        trackerStore.updateTracker(trackerID: tracker.id) { trackerCD in
            trackerCD.dayCounter = Int32(tracker.dayCounter)
        }
    }
    
    func pinTracker(tracker: Tracker) {
        trackerStore.updateTracker(trackerID: tracker.id) { trackerCD in
            trackerCD.isPinned = true
        }
    }
    
    func unpinTracker(tracker: Tracker) {
        trackerStore.updateTracker(trackerID: tracker.id) { trackerCD in
            trackerCD.isPinned = false
        }
    }
    
    func getTracker(trackerID: UUID) -> Tracker? {
        let trackerCategories = filterTrackers { tracker in tracker.id == trackerID }
        return trackerCategories.first?.trackers.first ?? nil
    }
    
    func getTrackerInfo(trackerID: UUID) -> TrackerInfo? {
        let categories = filterTrackers { tracker in tracker.id == trackerID }
        guard !categories.isEmpty ,
              let selectedCategory = categories.first,
              let selectedTracker = selectedCategory.trackers.first else { return nil }
        
        let selectedTrackerType = selectedTracker.schedule == WeekDay.allCases ? TrackerType.event : TrackerType.habbit
        let daysCompleted = completedTrackers.filter { $0.id == selectedTracker.id }.count
        return TrackerInfo(categoryName: selectedCategory.categoryName,
                           type: selectedTrackerType,
                           daysCounter: daysCompleted,
                           trackerInfo: selectedTracker)
    }
    
    func addNewTracker(tracker: Tracker, trackerCategory: String) {
        let category: TrackerCategory? = trackerCategoryStore.fetchByName(categoryName: trackerCategory)
        if category == nil {
            trackerCategoryStore.addCategory(trackerCategory: trackerCategory)
        } else {
            trackerStore.addTracker(tracker: tracker, category: trackerCategoryStore.getByName(categoryName: trackerCategory))
        }
    }
    
    func updateCurrentTracker(tracker: Tracker, categoryName: String) {
        let category: TrackerCategory? = trackerCategoryStore.fetchByName(categoryName: categoryName)
        if category == nil {
            trackerCategoryStore.addCategory(trackerCategory: categoryName)
        }
        trackerStore.updateTracker(trackerID: tracker.id) { trackerCD in
            trackerCD.name = tracker.name
            trackerCD.category = trackerCategoryStore.getByName(categoryName: categoryName)
            trackerCD.emoji = tracker.emoji
            trackerCD.color = UIColorMarshalling.serializeColor(tracker.color)
            if let schedule = tracker.schedule {
                trackerCD.schedule = try? encoder.encode(schedule)
            }
        }
    }
    
    func getCategoryByName(name: String) -> TrackerCategory? {
        trackerCategoryStore.fetchByName(categoryName: name)
    }
    
    func filterTrackers(filter: (Tracker) -> Bool) -> [TrackerCategory] {
        var filteredCategories: [TrackerCategory] = []
        categories.forEach { category in
            let currentTrackers = category.trackers.filter { tracker in
                filter(tracker)
            }
            if !currentTrackers.isEmpty { 
                let filteredCategory = TrackerCategory(categoryName: category.categoryName, trackers: currentTrackers)
                filteredCategories.append(filteredCategory)
            }
        }
        return filteredCategories
    }
    
    func filterTrackersByWeekDay(_ selectedDay: Int) -> [TrackerCategory] {
        return filterTrackers { tracker in
            guard let selectedDayEnum = WeekDay(rawValue: selectedDay) else { return false }
            return tracker.schedule?.contains(selectedDayEnum) == true
        }
    }
    
    func filterTrackersByName(_ searchText: String) -> [TrackerCategory] {
        return filterTrackers { tracker in
            return tracker.name.localizedStandardContains(searchText)
        }
    }
    
    func removeTracker(tracker: Tracker) {
        trackerStore.removeTracker(tracker: tracker)
    }
    
    func addTrackerRecord(trackerRecord: TrackerRecord) {
        trackerRecordStore.addRecord(trackerRecord: trackerRecord)
    }
    
    func deleteTrackerRecord(trackerRecord: TrackerRecord) {
        trackerRecordStore.deleteRecord(trackerRecord: trackerRecord)
    }
}

extension TrackerService: StoreDelegate {
    func didChangeContent() {
        categories = trackerCategoryStore.categories
        completedTrackers = Set(trackerRecordStore.records)
        
        NotificationCenter.default.post(name: TrackerService.changeContentNotification, object: nil)
    }
    
}
