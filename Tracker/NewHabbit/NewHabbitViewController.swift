import UIKit

final class NewHabbitViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let habbitLabel: UILabel = {
        let habbitLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 133, height: 22))
        habbitLabel.font = .systemFont(ofSize: 16, weight: .medium)
        habbitLabel.backgroundColor = .white
        habbitLabel.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        habbitLabel.attributedText =
        NSMutableAttributedString(string: "Новая привычка",
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        habbitLabel.translatesAutoresizingMaskIntoConstraints = false
        return habbitLabel
    }()
    
    private let habbitNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.textColor = .black
        textField.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3).cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 16
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
   
    let tableViewInstets = ["Категория", "Расписание"]
    
    private let createHabbitButton: UIButton = {
        let createHabbitButton = UIButton(type: .system)
        createHabbitButton.layer.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor
        createHabbitButton.layer.masksToBounds = true
        createHabbitButton.layer.cornerRadius = 16
        
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let titleAtributedString = NSAttributedString(string: "Создать",
                                                      attributes: titleAttribute)
        createHabbitButton.tintColor = .white
        createHabbitButton.setAttributedTitle(titleAtributedString, for: .normal)
        createHabbitButton.translatesAutoresizingMaskIntoConstraints = false
        createHabbitButton.addTarget(self, action: #selector(createHabbitButtonTapped), for: .touchUpInside)
        return createHabbitButton
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.backgroundColor = .white
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1).cgColor
        cancelButton.layer.borderWidth = 1
        
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let titleAtributedString = NSAttributedString(string: "Отменить",
                                                      attributes: titleAttribute)
        cancelButton.tintColor = .red
        cancelButton.setAttributedTitle(titleAtributedString, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return cancelButton
        
    }()
    
    private let centralTableView: UITableView = {
        let tableView = UITableView()
         tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
         tableView.layer.cornerRadius = 10
         tableView.backgroundColor = .white
         tableView.isScrollEnabled = false
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.register(ButtonCell.self, forCellReuseIdentifier: ButtonCell.identifier)
         tableView.separatorStyle = .singleLine
         tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
         tableView.clipsToBounds = true
         return tableView
    }()
    
    private let emojiCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       collectionView.translatesAutoresizingMaskIntoConstraints = false
       collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
       collectionView.register(EmojiSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojiSupplementaryView.identifier)
       collectionView.backgroundColor = .clear
       collectionView.isScrollEnabled = false
       return collectionView
       
   }()
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(ColorSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ColorSupplementaryView.identifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        return collectionView
    }()
    
    private lazy var lowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createHabbitButton])
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
     }


    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func createHabbitButtonTapped() {
        print("save habbit")
    }
}

//MARK: Setting Views
extension NewHabbitViewController {
    func setupView() {
        view.backgroundColor = .white
        centralTableView.delegate = self
        centralTableView.dataSource = self
        setCollections()
        constraintsForView()
    }
}

extension NewHabbitViewController {
    func constraintsForView() {
        view.addSubview(scrollView)
        scrollView.addSubview(centralTableView)
        scrollView.addSubview(habbitLabel)
        scrollView.addSubview(habbitNameTextField)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(lowStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            habbitLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 38),
            habbitLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            habbitLabel.heightAnchor.constraint(equalToConstant: 22),
            habbitLabel.widthAnchor.constraint(equalToConstant: 133),
            
            habbitNameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 110),
            habbitNameTextField.centerXAnchor.constraint(equalTo: habbitLabel.centerXAnchor),
            habbitNameTextField.widthAnchor.constraint(equalToConstant: 343),
            habbitNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            centralTableView.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor, constant: 24),
            centralTableView.centerXAnchor.constraint(equalTo: habbitNameTextField.centerXAnchor),
            centralTableView.heightAnchor.constraint(equalToConstant: 150),
            centralTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            emojiCollectionView.topAnchor.constraint(equalTo: centralTableView.bottomAnchor, constant: 32),
            emojiCollectionView.centerXAnchor.constraint(equalTo: centralTableView.centerXAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 220),
            emojiCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 80),
            colorCollectionView.centerXAnchor.constraint(equalTo: emojiCollectionView.centerXAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 220),
            colorCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            lowStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 46),
            lowStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            lowStackView.heightAnchor.constraint(equalToConstant: 60),
            
            createHabbitButton.heightAnchor.constraint(equalToConstant: 60),
            createHabbitButton.widthAnchor.constraint(equalToConstant: 161),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.bounds.height)
    }
   
    func setCollections() {
        EmojiCell().configure(with: emojiCollectionView, and: Emojis.emojis)
        ColorCell().configure(colorCollectionView: colorCollectionView, and: Colors.colors)
    }
}



extension NewHabbitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewInstets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as? ButtonCell else { return UITableViewCell() }
        let text = tableViewInstets[indexPath.row]
        let image = cell.myImageView.image
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        
        cell.layer.masksToBounds = true
        cell.configureCell(with: text, and: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: let category = CategoriesViewController()
            self.present(category, animated: true)
        case 1: let schedule = ScheduleViewController()
            self.present(schedule, animated: true)
        default: return
        }
    }
}

