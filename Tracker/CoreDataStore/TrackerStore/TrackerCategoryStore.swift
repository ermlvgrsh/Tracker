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
    
    lazy var resultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    override init(storeDelegate: StoreDelegate) {
        super.init(storeDelegate: storeDelegate)
        try? resultsController.performFetch()
    }
    
    func addCategory(trackerCategory: TrackerCategory) {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.categoryName = trackerCategory.categoryName
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
