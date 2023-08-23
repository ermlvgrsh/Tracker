import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let schedule: [WeekDay]?
    let color: UIColor
    let emoji: String
    let isPinned: Bool
    let dayCounter: Int
}
