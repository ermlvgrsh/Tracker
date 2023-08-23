import Foundation

protocol TrackerCategoryViewModelProtocol {
    var categories: [TrackerCategory] { get }
    var selectedCategory: TrackerCategory? { get }
    var currentNewCategoryName: String { get }
    var isPlaceholderHidden: Bool { get }
    var isTableViewHidden: Bool { get }
    
    func bindCategory()
    func didSelectTrackerCategory(category: TrackerCategory?)
    func didSaveNewTrackerCategory(category: TrackerCategory, newCategoryName: String?)
    func didCreateTrackerCategory()
}

final class TrackerCategoryViewModel: TrackerCategoryViewModelProtocol {
    
    private let trackerService = TrackerService.shared
    @Observable
    private(set) var categories: [TrackerCategory] = []
    
    @Observable
    private(set) var selectedCategory: TrackerCategory?
    
    @Observable
    private(set) var currentNewCategoryName: String = ""
    
    @Observable
    private(set) var isPlaceholderHidden = true
    
    @Observable
    private(set) var isTableViewHidden = true
    
    func bindCategory() {
        categories = trackerService.categories
        isCategoryEmpry()
        trackerService.$categories.bind { [weak self] trackerCategories in
            self?.categories = trackerCategories
            self?.isCategoryEmpry()
        }
    }
    
    func didSelectTrackerCategory(category: TrackerCategory?) {
        guard let category = category else { return }
        selectedCategory = category
    }
    
    func didSaveNewTrackerCategory(category: TrackerCategory, newCategoryName: String?) {
        categories.append(category)
        isCategoryEmpry()
        guard let currentNewCategoryName = newCategoryName else { return }
        self.currentNewCategoryName = currentNewCategoryName
        didCreateTrackerCategory()
    }
    
    
    func didCreateTrackerCategory() {
        if !currentNewCategoryName.isEmpty {
            trackerService.addCategory(categoryName: currentNewCategoryName)
        }
    }
    
    private func isCategoryEmpry() {
        if categories.isEmpty {
            isPlaceholderHidden = false
            return
        } else {
            isTableViewHidden = false
            isPlaceholderHidden = true
        }
    }
}
