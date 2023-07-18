import UIKit
import CoreData

final class IrregularEventStore: Store {
    
    private lazy var fetchRequest: NSFetchRequest<IrregularEventCoreData> = {
        let fetchRequest = IrregularEventCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \IrregularEventCoreData.id, ascending: true)]
        return fetchRequest
    }()
    
    func addEvent(event: IrregularEvent, category: EventCategoryCoreData?) {
        guard let category else { return }
        let eventTrackerCoreData = IrregularEventCoreData(context: context)
        eventTrackerCoreData.eventID = event.id
        eventTrackerCoreData.eventName = event.name
        eventTrackerCoreData.eventColor = UIColorMarshalling.serializeColor(event.color)
        eventTrackerCoreData.eventEmoji = event.emoji
        eventTrackerCoreData.category = category
        eventTrackerCoreData.dayCounter = Int32(event.dayCounter)
        
        save()
    }
    
    func fetchEventByID(eventID: UUID) -> IrregularEventCoreData? {
        fetchRequest.predicate = NSPredicate(format: "eventID == %@", eventID as NSUUID)
        let results = try! context.fetch(fetchRequest)
        return results.first
    }
}

extension IrregularEventCoreData {
    
    func toEvent() -> IrregularEvent? {
        guard let id = eventID,
              let name = eventName,
              let emoji = eventEmoji,
              let color = eventColor else { return nil }
        let dayCounter = Int(dayCounter)
        return IrregularEvent(id: id, name: name, emoji: emoji, color: UIColorMarshalling.deserialazeColor(color), dayCounter: dayCounter)
    }
}
