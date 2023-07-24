import CoreData

final class IrregularCategoryStore: Store {
    var categories: [IrregularEventCategory] {
        guard let eventsCoreData = resultsController.fetchedObjects else { return [] }
        let eventCategories = eventsCoreData.map { eventsCoreData in
            eventsCoreData.toEventCategory()
        }.compactMap{ $0 }
        return eventCategories
    }
    
    
    private lazy var fetchRequest: NSFetchRequest<EventCategoryCoreData> = {
        let fetchRequest = EventCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \EventCategoryCoreData.eventCategoryName, ascending: true)]
        return fetchRequest
    }()
    
    private lazy var resultsController: NSFetchedResultsController<EventCategoryCoreData> = {
       let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    var numberOfCategories: Int {
        resultsController.fetchedObjects?.count ?? 0
    }
    
    override init(storeDelegate: StoreDelegate) {
        super.init(storeDelegate: storeDelegate)
        try? resultsController.performFetch()
    }
    
    func addCategory(eventCategory: String) {
        let eventCategoryCoreData = EventCategoryCoreData(context: context)
        eventCategoryCoreData.eventCategoryName = eventCategory
        eventCategoryCoreData.events = []
        save()
    }
    
    func getByName(categoryName: String) -> EventCategoryCoreData? {
        let request = EventCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "eventCategoryName == %@", categoryName)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    func updateCategory(eventCategory: IrregularEventCategory) {
        guard let existingCategory = getByName(categoryName: eventCategory.categoryName) else { return }
        guard let existingEventsSet = existingCategory.events as? NSMutableSet else { return }
        
        for event in existingEventsSet {
            if let existingEvent = event as? IrregularEventCoreData,
               let updatedEvent = eventCategory.irregularEvents.first(where: { $0.id == existingEvent.eventID }) {
                existingEvent.dayCounter = Int32(updatedEvent.dayCounter)
            }
        }
        save()
    }
    
    func numberOfSections(section: Int) -> Int {
        let categories = self.categories

        guard section >= 0 && section < categories.count else {
            print("Error: Invalid section index.")
            return 0
        }

        return categories[section].irregularEvents.count
    }

    func fetchName(categoryName: String) -> IrregularEventCategory? {
        return getByName(categoryName: categoryName)?.toEventCategory()
    }
    
    func fetchCategory(at index: Int) -> String? {
        guard let categoryCoreData = resultsController.fetchedObjects else { return nil}
        guard index >= 0 && index < categoryCoreData.count else { return nil}
        return categoryCoreData[index].eventCategoryName
    }
}


extension IrregularCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
    }
}


extension EventCategoryCoreData {
    
    func toEventCategory() -> IrregularEventCategory? {
        guard let name = eventCategoryName, let eventsCoreData = events else { return nil }
        let events = eventsCoreData.map { eventsCoreData in
            (eventsCoreData as? IrregularEventCoreData)?.toEvent()
        }.compactMap{ $0 }
        return IrregularEventCategory(categoryName: name, irregularEvents: events)
    }
}
