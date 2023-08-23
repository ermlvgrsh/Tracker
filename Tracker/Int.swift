import Foundation

extension Int {
    func dayToString() -> String {
        return String.localizedStringWithFormat(NSLocalizedString("daysCompleted", comment: ""), self)
    }
}
