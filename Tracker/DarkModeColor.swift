import UIKit


final class DarkMode {
    
    let colorMode: UIColor = .systemBackground
    
    var tintAddButtonColor: UIColor = UIColor { (traits) -> UIColor in
        let isDarkMode = traits.userInterfaceStyle == .dark
        return isDarkMode ? UIColor.white : UIColor.black
    }
}
