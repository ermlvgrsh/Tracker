import Foundation

final class EventViewModel {
    
    private let eventService = IrregularEventService.shared
    
    @Observable
    private(set) var eventCategories: [IrregularEventCategory] = []
    
    @Observable
    private(set) var selectedEventCategory: IrregularEventCategory?
    
    @Observable
    private(set) var currentEventCategoryName: String = ""
    
    @Observable
    private(set) var isPlaceholderHidden: Bool = true
    
    @Observable
    private(set) var isTableViewHidden: Bool = true
    
    func bindCategory() {
        eventCategories = eventService.eventCategories
        isEventCategoryEmpty()
        eventService.$eventCategories.bind { [weak self] eventCategory in
            self?.eventCategories = eventCategory
            self?.isEventCategoryEmpty()
        }
    }
    
    func didSelectEventCategory(eventCategory: IrregularEventCategory?) {
        guard let eventCategory = eventCategory else { return }
        selectedEventCategory = eventCategory
    }
    
    func didSaveEventCategory(eventCategory: IrregularEventCategory, newEventCategory: String?) {
        eventCategories.append(eventCategory)
        isEventCategoryEmpty()
        guard let currentCategoryName = newEventCategory else { return }
        self.currentEventCategoryName = currentCategoryName
        didCreateEventCategory()
    }
    
    func didCreateEventCategory() {
        if !currentEventCategoryName.isEmpty {
            eventService.addCategory(categoryName: currentEventCategoryName)
        }
    }
    
    func isEventCategoryEmpty() {
        if eventCategories.isEmpty {
            isPlaceholderHidden = false
            return
        } else {
            isPlaceholderHidden = true
            isTableViewHidden = false
        }
    }
}
