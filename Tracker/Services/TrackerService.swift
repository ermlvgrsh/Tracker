import UIKit

final class TrackerService {
    
    static let shared = TrackerService()
    static let changeContentNotification = Notification.Name(rawValue: "ChangeContentNotification")
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var completedTrackers: Set<TrackerRecord> = []
    
    private lazy var trackerStore: TrackerStore = {
        let trackerStore = TrackerStore(storeDelegate: self)
        return trackerStore
    }()
    
    private lazy var trackerCategoryStore: TrackerCategoryStore = {
        let trackerCategoryStore = TrackerCategoryStore(storeDelegate: self)
        return trackerCategoryStore
    }()
    
    private lazy var trackerRecordStore: TrackerRecordStore = {
        let trackerRecordStore = TrackerRecordStore(storeDelegate: self)
        return trackerRecordStore
    }()
    
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
            if currentTrackers.count > 0 {
                filteredCategories.append(TrackerCategory(categoryName: category.categoryName, trackers: currentTrackers))
            }
        }
        return filteredCategories
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
