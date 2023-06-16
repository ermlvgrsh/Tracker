import Foundation

enum WeekDay: String, CaseIterable {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    
}

extension WeekDay {
    
    func shortName() -> String {
        switch self {
        case .Monday:
            return "Пн"
        case .Tuesday:
            return "Вт"
        case .Wednesday:
            return "Ср"
        case .Thursday:
            return "Чт"
        case .Friday:
            return "Пт"
        case .Saturday:
            return "Сб"
        case .Sunday:
            return "Вс"
        }
    }
}
