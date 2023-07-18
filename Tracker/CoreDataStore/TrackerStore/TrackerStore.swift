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
    
    func updateTracker(tracker: Tracker) {
        guard let existingTracker = fetchTrackerByID(tracker.id) else { return }
        existingTracker.dayCounter = Int32(tracker.dayCounter)
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
        return Tracker(id: id, name: name, schedule: weekDay, color: UIColorMarshalling.deserialazeColor(color), emoji: emoji, dayCounter: Int(dayCounter))
    }
    
}
