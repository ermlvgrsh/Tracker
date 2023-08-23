import Foundation

enum WeekDay: Int, CaseIterable, Codable {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    
}

extension WeekDay {
    
    func shortName() -> String {
        switch self {
        case .Monday:
            return "mn".localized
        case .Tuesday:
            return "tue".localized
        case .Wednesday:
            return "wed".localized
        case .Thursday:
            return "thu".localized
        case .Friday:
            return "fr".localized
        case .Saturday:
            return "sat".localized
        case .Sunday:
            return "sun".localized
        }
    }
}
