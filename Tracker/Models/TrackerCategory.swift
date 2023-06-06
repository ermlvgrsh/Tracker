import Foundation

struct TrackerCategory {
    let categoryName: String
    
    var trackers: [Tracker]
    
    func tracker(at index: Int) -> Tracker? {
        guard index >= 0, index < trackers.count else { return nil }
        return tracker(at: index)
    }
}
