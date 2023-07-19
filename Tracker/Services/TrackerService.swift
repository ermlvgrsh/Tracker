import UIKit

final class TrackerService {
    
    static let shared = TrackerService()
    static let changeContentNotification = Notification.Name(rawValue: "ChangeContentNotification")
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var completedTrackers: Set<TrackerRecord> = []
    
    var filteredTrackers: [TrackerCategory] = []
    
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
    
    private init() {
        categories = trackerCategoryStore.categories
        completedTrackers = Set(trackerRecordStore.records)
    }
    
    func updateTracker(tracker: Tracker) {
        trackerStore.updateTracker(tracker: tracker)
    }


    func addNewTracker(tracker: Tracker, trackerCategory: TrackerCategory) {
        let category: TrackerCategory? = trackerCategoryStore.fetchByName(categoryName: trackerCategory.categoryName)
        if category == nil {
            trackerCategoryStore.addCategory(trackerCategory: trackerCategory)
        }
        trackerStore.addTracker(tracker: tracker, category: trackerCategoryStore.getByName(categoryName: trackerCategory.categoryName))
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
        filteredTrackers = filteredCategories
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
