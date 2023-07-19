import CoreData


final class EventRecordStore: Store {
    

    var records: [IrregularEventRecord] {
        guard let eventRecordCoreData = resultsController.fetchedObjects else { return [] }
        let eventRecords = eventRecordCoreData.map { eventRecordCoreData in
            eventRecordCoreData.toEventRecord()
        }.compactMap({ $0 })
        return eventRecords
    }
    
    private lazy var fetchRequest: NSFetchRequest<EventRecordCoreData> = {
        let request = EventRecordCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \EventRecordCoreData.eventID, ascending: true),
            NSSortDescriptor(keyPath: \EventRecordCoreData.eventDate, ascending: true)]
        return request
    }()
    
    private lazy var resultsController: NSFetchedResultsController<EventRecordCoreData> = {
       let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                   managedObjectContext: context,
                                                   sectionNameKeyPath: nil,
                                                   cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    override init(storeDelegate: StoreDelegate) {
        super.init(storeDelegate: storeDelegate)
        try? resultsController.performFetch()
    }
    
    func addRecord(record: IrregularEventRecord) {
        let request = EventRecordCoreData(context: context)
        request.eventID = record.id
        request.eventDate = record.date
        save()
    }
    
    func deleteRecord(record: IrregularEventRecord) {
        let request = EventRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "eventID == %@ AND eventDate == %@", argumentArray: [record.id, record.date])
        do {
            let records = try context.fetch(request)
            guard let recordToDelete = records.first else {
                print("NOT FOUND")
                return
            }
            context.delete(recordToDelete)
            save()
        } catch {
            print("UNEXPECTED ERROR \(error)")
        }
        save()
    }
}



extension EventRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
    }
    
}

extension EventRecordCoreData {
    
    func toEventRecord() -> IrregularEventRecord? {
        guard let date = eventDate, let id = eventID else { return nil }
        return IrregularEventRecord(id: id, date: date)
    }
}
