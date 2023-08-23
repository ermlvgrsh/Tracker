import UIKit
import CoreData



final class TrackerCategoryStore: Store {
    var categories: [TrackerCategory] {
        guard let trackerCategoryCoreData = resultsController.fetchedObjects else { return [] }
        let categories = trackerCategoryCoreData.map { trackerCategoryCoreData in
            trackerCategoryCoreData.toTrackerCategory(decoder: decoder)
        }.compactMap { $0 }
        return categories
    }
    
    private let decoder = JSONDecoder()
    
    private lazy var fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.categoryName, ascending: true)]
        return fetchRequest
    }()
    
    var numberOfCategories: Int {
        resultsController.fetchedObjects?.count ?? 0
    }
    
    lazy var resultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    override init(storeDelegate: StoreDelegate) {
        super.init(storeDelegate: storeDelegate)
        try? resultsController.performFetch()
    }
    
    func numberOfSections(section: Int) -> Int {
        let categories = self.categories
        
        guard section >= 0 && section < categories.count else {
            print("Error: Invalid section index.")
            return 0
        }
        
        return categories[section].trackers.count
    }
    
    func fetchCategory(at index: Int) -> String? {
        guard let categoryCoreData = resultsController.fetchedObjects else { return nil}
        guard index >= 0 && index < categoryCoreData.count else { return nil}
        return categoryCoreData[index].categoryName
    }
    
    
    func addCategory(trackerCategory: String) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.categoryName = trackerCategory
        trackerCategoryCoreData.trackers = []
        save()
    }
    
    func getByName(categoryName: String) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "categoryName == %@", categoryName)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    func fetchByName(categoryName: String) -> TrackerCategory? {
        return getByName(categoryName: categoryName)?.toTrackerCategory(decoder: decoder)
    }
}



extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
    }
}

extension TrackerCategoryCoreData {
    
    func toTrackerCategory(decoder: JSONDecoder) -> TrackerCategory? {
        guard let name = categoryName, let trackersCoreData = trackers else { return nil }
        let trackers = trackersCoreData.map { trackersCoreData in
            (trackersCoreData as? TrackerCoreData)?.toTracker(decoder: decoder)
        }.compactMap{ $0 }
        
        return TrackerCategory(categoryName: name, trackers: trackers)
    }
}
