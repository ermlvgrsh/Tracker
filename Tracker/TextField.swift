import UIKit

class CustomToolBar: UIToolbar {
    
    override var intrinsicContentSize: CGSize {
        let height: CGFloat = 44.0
        let width: CGFloat = UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
}
extension UIViewController {
    
    func addDoneButtonToKeyboard() {
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneKeyboardTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBar = CustomToolBar()
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        
        for view in self.view.subviews {
            if let textField = view as? UITextField  {
                textField.inputAccessoryView = toolBar
            } else if let searchField = view as? UISearchTextField {
                searchField.inputAccessoryView = toolBar
            } else if let scrollView = view as? UIScrollView {
                for subview in scrollView.subviews {
                    if let textField = subview as? UITextField {
                        textField.inputAccessoryView = toolBar
                    }
                }
            }
        }
    }
    
    @objc private func doneKeyboardTapped() {
        self.view.endEditing(true)
    }
}
