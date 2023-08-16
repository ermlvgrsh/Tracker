import UIKit
import CoreData


final class TrackerStore: Store {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private lazy var fetchRequest: NSFetchRequest<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.id, ascending: true)]
        return fetchRequest
    }()
    
    lazy var resultsController: NSFetchedResultsController<TrackerCoreData> = {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    override init(storeDelegate: StoreDelegate) {
        super.init(storeDelegate: storeDelegate)
        try? resultsController.performFetch()
    }
    
    func addTracker(tracker: Tracker, category: TrackerCategoryCoreData?) {
        guard let category else { return }
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = UIColorMarshalling.serializeColor(tracker.color)
        trackerCoreData.category = category
        trackerCoreData.dayCounter = Int32(tracker.dayCounter)
        if let schedule = tracker.schedule {
            trackerCoreData.schedule = try? encoder.encode(schedule)
        }
        save()
    }
    
    func updateTracker(trackerID: UUID, update: (TrackerCoreData) -> Void) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerID as CVarArg)
        request.fetchLimit = 1
        guard let tracker = try? context.fetch(request).first else { return }
        update(tracker)
        save()
    }
    func removeTracker(tracker: Tracker) {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        guard let trackers = try? context.fetch(request) else { return }
        for tracker in trackers {
            context.delete(tracker)
        }
        save()
    }
    
    func fetchTrackerByID(_ tracker: UUID) -> TrackerCoreData? {
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker as NSUUID)
        let results = try! context.fetch(fetchRequest)
        return results.first
    }
}
extension TrackerCoreData {
    
    func toTracker(decoder: JSONDecoder) -> Tracker? {
        guard let id = id,
              let name = name,
              let color = color,
              let emoji = emoji else { return nil }
        var weekDay: [WeekDay]? = nil
        let dayCounter = dayCounter
        if let schedule = schedule {
            weekDay = try? decoder.decode([WeekDay].self, from: schedule)
        }
        return Tracker(id: id, name: name,
                       schedule: weekDay,
                       color: UIColorMarshalling.deserialazeColor(color),
                       emoji: emoji,
                       isPinned: isPinned,
                       dayCounter: Int(dayCounter))
    }
    
}
extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
    }

}
