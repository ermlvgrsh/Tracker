import CoreData


final class TrackerRecordStore: Store {
    
    var records: [TrackerRecord] {
        guard let trackerRecordsCoreData = resultsController.fetchedObjects else { return [] }
       let trackerRecords = trackerRecordsCoreData.map { trackerRecordCoreData in
           trackerRecordCoreData.toTrackerRecord()
       }.compactMap{ $0 }
        return trackerRecords
    }
    
    private lazy var fetchRequest: NSFetchRequest<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.id, ascending: true),
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
        ]
        return fetchRequest
    }()
    
    private lazy var resultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                           managedObjectContext: context,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        resultsController.delegate = self
        return resultsController
    }()
    
    override init(storeDelegate: StoreDelegate) {
        super.init(storeDelegate: storeDelegate)
        try? resultsController.performFetch()
    }
    
    func addRecord(trackerRecord: TrackerRecord) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.id = trackerRecord.id
        trackerRecordCoreData.date = trackerRecord.date
     
        save()
    }
    
    func deleteRecord(trackerRecord: TrackerRecord) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND date == %@", argumentArray: [trackerRecord.id, trackerRecord.date])
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
     
    }
}


extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        storeDelegate?.didChangeContent()
    }
}

extension TrackerRecordCoreData {
    
    func toTrackerRecord() -> TrackerRecord? {
        guard let date = date, let id = id else { return nil }
        return TrackerRecord(id: id, date: date)
    }
}
