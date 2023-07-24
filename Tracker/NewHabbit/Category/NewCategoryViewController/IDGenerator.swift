import Foundation

class IDGenerator {
    private var lastID: UInt = 0
    
    func generateID() -> UInt {
        let id = lastID
        lastID += 1
        return id
    }
}
