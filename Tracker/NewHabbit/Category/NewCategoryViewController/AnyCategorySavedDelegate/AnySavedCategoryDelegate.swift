import UIKit


class AnySavedCategoryDelegate <CategoryType>: NewCategoryDelegete {
    
    private let _didSaveCategory: (CategoryType, String?) -> Void
    private var savedNamedCategory: String?
    
    init(_ didSaveCategory: @escaping (CategoryType, String?) -> Void) {
        self._didSaveCategory = didSaveCategory
    }
    
    func didSaveCategory(_ category: CategoryType, namedCategory: String?) {
        savedNamedCategory = namedCategory
        _didSaveCategory(category, savedNamedCategory)
    }
    
    
}
