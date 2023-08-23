import UIKit
import CoreData

final class IrregularEventStore: Store {
    
    private lazy var fetchRequest: NSFetchRequest<IrregularEventCoreData> = {
        let fetchRequest = IrregularEventCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \IrregularEventCoreData.eventID, ascending: true)]
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
    
    lazy var resultsController: NSFetchedResultsController<IrregularEventCoreData> = {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    override init(storeDelegate: StoreDelegate) {
        super.init(storeDelegate: storeDelegate)
        try? resultsController.performFetch()
    }
    func removeEvent(event: IrregularEvent) {
        let request = IrregularEventCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", event.id as CVarArg)
        guard let events = try? context.fetch(request) else { return }
        for event in events {
            context.delete(event)
        }
        save()
    }
    
    func fetchEventByID(eventID: UUID) -> IrregularEventCoreData? {
        fetchRequest.predicate = NSPredicate(format: "eventID == %@", eventID as NSUUID)
        let results = try! context.fetch(fetchRequest)
        return results.first
    }
    
    func updateEvent(event: IrregularEvent) {
        guard let existingEvent = fetchEventByID(eventID: event.id) else { return }
        existingEvent.dayCounter = Int32(event.dayCounter)
        save()
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

extension IrregularEventStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
    }
}
