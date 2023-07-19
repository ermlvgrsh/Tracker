import UIKit


final class IrregularEventService {
    
    static let shared = IrregularEventService()
    static let changeContentNotification = Notification.Name("ChangeContentNotification")
    
    private(set) var eventCategories: [IrregularEventCategory] = []
    private(set) var completedEvents: Set<IrregularEventRecord> = []
    var filteredEvents: [IrregularEventCategory] = []
    lazy var irregularEventStore: IrregularEventStore = {
       let eventStore = IrregularEventStore(storeDelegate: self)
        return eventStore
    }()
    
    private lazy var eventCategoryStore: IrregularCategoryStore = {
        let eventCategory = IrregularCategoryStore(storeDelegate: self)
        return eventCategory
    }()
    
    private lazy var eventRecordStore: EventRecordStore = {
        let eventRecord = EventRecordStore(storeDelegate: self)
        return eventRecord
    }()
    
    
    private init() {
        eventCategories = eventCategoryStore.categories
        completedEvents = Set(eventRecordStore.records)
    }
    
    
    func addNewEvent(event: IrregularEvent, eventCategory: IrregularEventCategory) {
        let category: IrregularEventCategory? = eventCategoryStore.fetchName(categoryName: eventCategory.categoryName)
        if category == nil {
            eventCategoryStore.addCategory(eventCategory: eventCategory)
        }
        irregularEventStore.addEvent(event: event, category: eventCategoryStore.getByName(categoryName: eventCategory.categoryName))
    }
    
    func filterEvents(filter: (IrregularEvent) -> Bool) -> [IrregularEventCategory] {
        var filteredCategories: [IrregularEventCategory] = []
        eventCategories.forEach { eventCategory in
            let currentTrackers = eventCategory.irregularEvents.filter { event in
                filter(event)
            }
            if currentTrackers.count > 0 {
                filteredCategories.append(IrregularEventCategory(categoryName: eventCategory.categoryName, irregularEvents: currentTrackers))
            }
        }
        filteredEvents = filteredCategories
        return filteredCategories
    }

    func updateEvent(event: IrregularEvent) {
        irregularEventStore.updateEvent(event: event)
    }

    func fetchEventCategory(at index: Int) -> String? {
        eventCategoryStore.fetchCategory(at: index)
    }
    
    func fetchIrregularEvent(at indexPath: IndexPath) -> IrregularEvent? {
        let eventCore = irregularEventStore.resultsController.object(at: indexPath)
        return eventCore.toEvent()
    }
    
    func addEventRecord(eventRecord: IrregularEventRecord) {
        eventRecordStore.addRecord(record: eventRecord)
    }
    
    func deleteEventRecord(eventRecord: IrregularEventRecord) {
        eventRecordStore.deleteRecord(record: eventRecord)
    }
 }



extension IrregularEventService: StoreDelegate {
    func didChangeContent() {
        eventCategories = eventCategoryStore.categories
        completedEvents = Set(eventRecordStore.records)
        NotificationCenter.default.post(name: IrregularEventService.changeContentNotification, object: nil)
    }
    
    
}
