import UIKit

protocol NewTrackerDelegate: AnyObject {
    func didCreateTracker(newTracker: Tracker, with category: TrackerCategory)
}


final class NewHabbitViewController: UIViewController {
    
    var selectedName: String?
    var selectedColor: UIColor?
    var selectedEmoji: String?
    var selectedCategory: TrackerCategory?
    var selectedSchedule: [WeekDay]? = []
    var dayCounter = 0
    weak var delegate: NewTrackerDelegate?
    var trackerService: TrackerService = TrackerService.shared
    var viewModel = TrackerCategoryViewModel()
    
    var isShifted = false
    var selectedEmojiIndexPath: IndexPath?
    var selectedColorIndexPath: IndexPath?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let habbitLabel: UILabel = {
        let habbitLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 133, height: 22))
        habbitLabel.font = .systemFont(ofSize: 16, weight: .medium)
        habbitLabel.backgroundColor = .white
        habbitLabel.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        habbitLabel.attributedText =
        NSMutableAttributedString(string: "new_habbit".localized,
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        habbitLabel.translatesAutoresizingMaskIntoConstraints = false
        return habbitLabel
    }()
    
    private let habbitNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "tracker_name".localized
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

    
    private let limitCharacterLabel: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 286, height: 22))
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .white
        label.textColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.attributedText = NSMutableAttributedString(string: "limit".localized, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
        
    }()
    
    lazy var deleteButton: UIButton = {
        guard let xMarkImage = UIImage(named: "xmark.circle") else { fatalError() }
        
        let button = UIButton(type: .system)
        button.setImage(xMarkImage, for: .normal)
        button.tintColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.addTarget(self, action: #selector(deleteHabbitName), for: .touchUpInside)
        return button
    }()
    
    private let deleteButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()

    
    @objc func deleteHabbitName() {
        habbitNameTextField.text = ""
        limitCharacterLabel.isHidden = true
        if isShifted {
            moveViewDown(by: 38)
        }
        deleteButton.isHidden = true
    }
    
    let tableViewInstets = ["category".localized, "schedule".localized]
    
    lazy var createHabbitButton: UIButton = {
        let createHabbitButton = UIButton(type: .system)
        createHabbitButton.layer.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor
        createHabbitButton.layer.masksToBounds = true
        createHabbitButton.layer.cornerRadius = 16
        
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let titleAtributedString = NSAttributedString(string: "create".localized,
                                                      attributes: titleAttribute)
        createHabbitButton.tintColor = .white
        createHabbitButton.setAttributedTitle(titleAtributedString, for: .normal)
        createHabbitButton.translatesAutoresizingMaskIntoConstraints = false
        createHabbitButton.addTarget(self, action: #selector(createHabbitButtonTapped), for: .touchUpInside)
        return createHabbitButton
    }()
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.backgroundColor = .white
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.borderColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1).cgColor
        cancelButton.layer.borderWidth = 1
        
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let titleAtributedString = NSAttributedString(string: "cancel".localized,
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
         tableView.layer.cornerRadius = 16
         tableView.backgroundColor = .white
         tableView.isScrollEnabled = false
         tableView.translatesAutoresizingMaskIntoConstraints = false
         tableView.register(NewHabbitCell.self, forCellReuseIdentifier: NewHabbitCell.identifier)
         tableView.separatorStyle = .singleLine
         tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
         tableView.clipsToBounds = true
         return tableView
    }()
    
    lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 14
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(EmojiSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojiSupplementaryView.identifier)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
        
    }()
    
    lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 17
        layout.minimumLineSpacing = 12
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
        guard let name = selectedName,
              let emoji = selectedEmoji,
              let color = selectedColor,
              let category = selectedCategory,
              let schedule = selectedSchedule else { return }
        
        let newTracker = Tracker(id: UUID(), name: name, schedule: schedule, color: color, emoji: emoji, dayCounter: dayCounter)

        delegate?.didCreateTracker(newTracker: newTracker, with: category)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func setTextFieldDelegate() {
        habbitNameTextField.delegate = self
    }
    
    func setTableView() {
        centralTableView.delegate = self
        centralTableView.dataSource = self
    }
    
    func configure(with emojiCollectionView: UICollectionView, and data: [String]) {
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
    }
    
    func configure(with colorCollectionView: UICollectionView, and colors: [Colors]) {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
    }
    func setCollections() {
        configure(with: colorCollectionView, and: Colors.colors)
        configure(with: emojiCollectionView, and: Emojis.emojis)
    }
}

//MARK: Setting Views
extension NewHabbitViewController {
    func setupView() {
        view.backgroundColor = .white
        constraintsForView()
        setCollections()
        setTableView()
        setTextFieldDelegate()
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension NewHabbitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewInstets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewHabbitCell.identifier, for: indexPath) as? NewHabbitCell else { return UITableViewCell() }
        let text = tableViewInstets[indexPath.row]
        let image = cell.iconImageView.image
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        cell.layer.masksToBounds = true
        cell.configureCell(with: text, and: image)
        return cell
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
            category.delegate = self
            viewModel.bindCategory()
            self.present(category, animated: true)
        case 1: let schedule = ScheduleViewController()
            schedule.delegate = self
            self.present(schedule, animated: true)
        default: return
        }
        centralTableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: UICollectionViewDataSource
extension NewHabbitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell() }
            let index = indexPath.row % Emojis.count
            let emoji = Emojis[index]
            
            emojiCell.titleLabel.text = emoji
            
            return emojiCell
        } else {
            guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
            let index = indexPath.row % Colors.count
            let color = Colors.colors[index]
            colorCell.configureCell(with: color.color)
            return colorCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView == emojiCollectionView else { return Colors.count }
        return Emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader: id = "header"
        case UICollectionView.elementKindSectionFooter: id = "footer"
        default: id = ""
        }
        guard collectionView == emojiCollectionView  else {
            guard let colorView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? ColorSupplementaryView else {
                return UICollectionReusableView() }
            
            colorView.titleLabel.text = "color".localized
            return colorView
        }
        guard let emojiView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? EmojiSupplementaryView else { return UICollectionReusableView() }
        emojiView.titleLabel.text = "Emoji"
        return emojiView
    }
}

//MARK: UICollectionViewDelegate
extension NewHabbitViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case emojiCollectionView:
            if let previousSelected = selectedEmojiIndexPath {
                if let previousSelectedEmojiCell = collectionView.cellForItem(at: previousSelected) as? EmojiCell {
                    previousSelectedEmojiCell.emojiBackgroundView.isHidden = true
                }
            }
            guard let selectedEmojiCell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {
                fatalError("Couldn't choose emoji!")
            }
            selectedEmojiCell.emojiBackgroundView.isHidden = false
            selectedEmojiIndexPath = indexPath
            selectedEmoji = selectedEmojiCell.titleLabel.text
            

        case colorCollectionView:
            if let previousSelected = selectedColorIndexPath {
                if let previousSelectedColorCell = collectionView.cellForItem(at: previousSelected) as? ColorCell {
                    previousSelectedColorCell.colorBackgroundView.isHidden = true
                }
            }
            guard let selectedColorCell = collectionView.cellForItem(at: indexPath) as? ColorCell else {
                fatalError("Couldn't choose color!")
            }
            selectedColorCell.colorBackgroundView.isHidden = false
            selectedColorIndexPath = indexPath
            selectedColor = Colors.colors[indexPath.row].color
            if !isTrackerComplete() {
                createHabbitButton.isEnabled = false
            } else {
                createHabbitButton.layer.backgroundColor = UIColor.black.cgColor
                createHabbitButton.isEnabled = true
            }
            
        default:
            break
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension NewHabbitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == emojiCollectionView {
            guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else {
                fatalError("Unable to dequeue EmojiCell")
            }
            return emojiCell.calculateEmojiCell(collectionView: emojiCollectionView)
        } else {
            guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else {
                fatalError("Unable to dequeue ColorCell")
            }
            return colorCell.calculateColorCell(collectionView: colorCollectionView)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

//MARK: UITextFieldDelegate
extension NewHabbitViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButtonToKeyboard()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let habbitName = textField.text ?? ""
        
        let newHabbitName = (habbitName as NSString).replacingCharacters(in: range, with: string)
        let limitCharacter = 38
        let amount: CGFloat = 38
      
        if newHabbitName.count > 0 {
            showDeleteButton()
        }
        
        if newHabbitName.count > limitCharacter && !isShifted {
            moveViewUp(by: amount)
            return false
        }
        
        if newHabbitName.count <= limitCharacter && isShifted {
            moveViewDown(by: amount)
        }
        
        return newHabbitName.count <= limitCharacter
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedName = textField.text
        deleteButton.isHidden = true
    }
}

extension NewHabbitViewController {
    private func showDeleteButton() {
        deleteButtonContainerView.isHidden = false
        deleteButton.isHidden = false
    }
    
    private func moveViewUp(by amount: CGFloat) {
        limitCharacterLabel.isHidden = false
        centralTableView.frame.origin.y += amount
        emojiCollectionView.frame.origin.y += amount
        colorCollectionView.frame.origin.y += amount
        lowStackView.frame.origin.y += amount
        scrollView.contentSize.height += amount
        
        isShifted = true
    }
    
    private func moveViewDown(by amount: CGFloat) {
        limitCharacterLabel.isHidden = true
        centralTableView.frame.origin.y -= amount
        emojiCollectionView.frame.origin.y -= amount
        colorCollectionView.frame.origin.y -= amount
        lowStackView.frame.origin.y -= amount
        scrollView.contentSize.height -= amount
        
        isShifted = false
    }
    
    func constraintsForView() {
        view.addSubview(scrollView)
        scrollView.addSubview(centralTableView)
        scrollView.addSubview(habbitLabel)
        scrollView.addSubview(habbitNameTextField)
        scrollView.addSubview(limitCharacterLabel)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(lowStackView)
        
        scrollView.addSubview(deleteButtonContainerView)
        deleteButtonContainerView.addSubview(deleteButton)
        
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
            habbitNameTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            habbitNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            deleteButtonContainerView.leadingAnchor.constraint(equalTo: habbitNameTextField.trailingAnchor, constant: -41),
            deleteButtonContainerView.trailingAnchor.constraint(equalTo: habbitNameTextField.trailingAnchor),
            deleteButtonContainerView.topAnchor.constraint(equalTo: habbitNameTextField.topAnchor),
            deleteButtonContainerView.bottomAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor),
            deleteButtonContainerView.widthAnchor.constraint(equalToConstant: 41),
                    
            deleteButton.centerYAnchor.constraint(equalTo: habbitNameTextField.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: habbitNameTextField.trailingAnchor, constant: -12),
            deleteButton.widthAnchor.constraint(equalToConstant: 17),
            deleteButton.heightAnchor.constraint(equalToConstant: 17),
            
            limitCharacterLabel.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor, constant: 8),
            limitCharacterLabel.centerXAnchor.constraint(equalTo: habbitLabel.centerXAnchor),
            limitCharacterLabel.widthAnchor.constraint(equalToConstant: 286),
            limitCharacterLabel.heightAnchor.constraint(equalTo: habbitLabel.heightAnchor),
            
            centralTableView.topAnchor.constraint(equalTo: habbitNameTextField.bottomAnchor, constant: 24),
            centralTableView.centerXAnchor.constraint(equalTo: habbitNameTextField.centerXAnchor),
            centralTableView.heightAnchor.constraint(equalToConstant: 150),
            centralTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            emojiCollectionView.topAnchor.constraint(equalTo: centralTableView.bottomAnchor, constant: 32),
            emojiCollectionView.centerXAnchor.constraint(equalTo: centralTableView.centerXAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 220),
            emojiCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            

            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 47),
            colorCollectionView.centerXAnchor.constraint(equalTo: emojiCollectionView.centerXAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 220),
            colorCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            lowStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 46),
            lowStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            lowStackView.heightAnchor.constraint(equalToConstant: 60),
            lowStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            createHabbitButton.heightAnchor.constraint(equalToConstant: 60),
            createHabbitButton.widthAnchor.constraint(equalToConstant: 161),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        colorCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

    
   private func isTrackerComplete() -> Bool {
        guard let name = selectedName,
              let category = selectedCategory,
              !name.isEmpty,
              !category.categoryName.isEmpty,
              selectedEmoji != nil,
              selectedColor != nil,
              let selectedSchedule = selectedSchedule,
              !selectedSchedule.isEmpty else { return false }
        return true
    }
}

extension NewHabbitViewController: CategoriesDelegate {

    func didSelectCategory(_ selectedCategory: TrackerCategory) {
        self.selectedCategory = selectedCategory
        guard let cell = centralTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewHabbitCell else { fatalError() }
        cell.subLabel.text = selectedCategory.categoryName
        cell.moveLabel()
    }
}

extension NewHabbitViewController: ScheduleViewControllerDelegate {
    
    func didSetSchedule(for weekDays: [WeekDay]) {
        guard let cell = centralTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? NewHabbitCell else { fatalError() }
        if weekDays.count == WeekDay.allCases.count {
            cell.subLabel.text = "Каждый день"
            cell.moveLabel()
            selectedSchedule = weekDays
        } else {
            let shortenedDays = weekDays.map { $0.shortName() }
            let shortenedDaysString = shortenedDays.joined(separator: ", ")
            cell.subLabel.text = shortenedDaysString
            cell.moveLabel()
            selectedSchedule = weekDays
        }
    }
}
