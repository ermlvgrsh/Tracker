import Foundation

struct TrackerFlowView {
    let flow: TrackerFlow
    let trackerInfo: TrackerInfo
}

enum TrackerFlow {
    case create
    case edit
}

struct TrackerInfo {
    let categoryName: String?
    let type: TrackerType
    let daysCounter: Int?
    let trackerInfo: Tracker?
}
