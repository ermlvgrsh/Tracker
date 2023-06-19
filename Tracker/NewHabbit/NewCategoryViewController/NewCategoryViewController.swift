import UIKit

protocol NewCategoryDelegete: AnyObject {
    func didSaveCategory(_ category: TrackerCategory, namedCategory: String?)
}

final class NewCategoryViewController: UIViewController {
    
    weak var delegate: NewCategoryDelegete?
    
    var namedCategory: String?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let newCategoryLabel: UILabel = {
        let label = UILabel(frame:CGRect(x: 0, y: 0, width: 133, height: 22))
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .white
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        label.attributedText =
        NSMutableAttributedString(string: "Новая категория",
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.textColor = .black
        textField.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        return textField
     }()
    
    @objc func doneButtonTapped() {
        guard let categoryName = categoryTextField.text else { return }
        var categories = CategoriesViewController().categories
        let newCategory = TrackerCategory(categoryName: categoryName, trackers: [])
        categories.append(newCategory)
        delegate?.didSaveCategory(newCategory, namedCategory: namedCategory)
        dismiss(animated: true)
    }
    
    @objc func textFieldDidChanged(_ textfield: UITextField) {
        if textfield.text?.isEmpty == false {
            addCategory.layer.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
        } else {
            addCategory.backgroundColor = .white
            addCategory.layer.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor
        }
    }
    
    private let addCategory: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 335, height: 60)
        button.layer.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor
        button.layer.cornerRadius = 16
        
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let titleAtributedString = NSAttributedString(string: "Готово",
                                                      attributes: titleAttribute)
        button.tintColor = .white
        button.setAttributedTitle(titleAtributedString, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

     }
    
    func setupUI() {
        categoryTextField.delegate = self
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(categoryTextField)
        scrollView.addSubview(addCategory)
        scrollView.addSubview(newCategoryLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
            newCategoryLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            newCategoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38),
            newCategoryLabel.heightAnchor.constraint(equalToConstant: 22),
            
            categoryTextField.topAnchor.constraint(equalTo: newCategoryLabel.bottomAnchor, constant: 38),
            categoryTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            categoryTextField.widthAnchor.constraint(equalToConstant: 343),
            categoryTextField.heightAnchor.constraint(equalToConstant: 75),
            
            addCategory.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 489),
            addCategory.centerXAnchor.constraint(equalTo: newCategoryLabel.centerXAnchor),
            
            addCategory.widthAnchor.constraint(equalToConstant: 335),
            addCategory.heightAnchor.constraint(equalToConstant: 60)
        
        ])
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        namedCategory = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButtonToKeyboard()
    }
}


