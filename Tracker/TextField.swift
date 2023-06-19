
import UIKit

extension UIViewController {
    
    func addDoneButtonToKeyboard() {
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneKeyboardTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let toolBar = UIToolbar()
        toolBar.items = [flexibleSpace, doneButton]
        toolBar.sizeToFit()
        
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
