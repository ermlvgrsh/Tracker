import Foundation


final class TrackerCategoryViewModel {
    private let trackerService = TrackerService.shared
    @Observable
    private(set) var categories: [TrackerCategory] = []
    
    @Observable
    private(set) var selectedCategory: TrackerCategory?
    
    @Observable
    private(set) var currenNewCategoryName: String = ""
    
    @Observable
    private(set) var isPlaceholderHidden = true
    
    
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
        self.currenNewCategoryName = currentNewCategoryName
        didCreateTrackerCategory()
    }
    
    func didCreateTrackerCategory() {
        if !currenNewCategoryName.isEmpty {
            trackerService.addCategory(categoryName: currenNewCategoryName)
        }
    }
    
    private func isCategoryEmpry() {
        if categories.isEmpty {
            isPlaceholderHidden = false
            return
        } else {
            isPlaceholderHidden = true
        }
    }
}
