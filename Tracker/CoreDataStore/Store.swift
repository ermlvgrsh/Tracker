import UIKit
import CoreData

struct StoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndex: IndexSet
    let deletedIndex: IndexSet
    let updatedIndex: IndexSet
    let movedIndexes: Set<Move>
}

class Store: NSObject {
    
    weak var storeDelegate: StoreDelegate? = nil
    
    lazy var context: NSManagedObjectContext = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return context
    }()
    
    init(storeDelegate: StoreDelegate) {
        self.storeDelegate = storeDelegate
        super.init()
    }
    
    internal func save() {
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
