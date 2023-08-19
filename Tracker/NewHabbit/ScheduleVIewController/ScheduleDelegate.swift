import Foundation


protocol ScheduleDelegate {
    func didSelectSchedule(selectedDays: Set<WeekDay>)
}
