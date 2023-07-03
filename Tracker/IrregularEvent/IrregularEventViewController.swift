import UIKit


final class IrregularEventViewController: UIViewController {
    
    var selectedName: String?
    var selectedEmoji: String?
    var selectedColor: UIColor?
    var selectedEmojiIndexPath: IndexPath?
    var selectedColorIndexPath: IndexPath?
    var selectedCategory: TrackerCategory?
    var isShifted: Bool = false
    
   private let irregularEventLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .white
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        label.attributedText =
        NSMutableAttributedString(string: "Новое нерегулярное событие",
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = false
        return scrollView
    }()
    
   private let irregularNameTextField: UITextField = {
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
    
    let categoryViewInset = ["Категория"]
    
    private let textLimitLabel: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 286, height: 22))
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.backgroundColor = .white
        label.textColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        label.attributedText = NSMutableAttributedString(string: "Ограничение 38 символов", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let deleteButton: UIButton = {
        guard let image = UIImage(named: "xmark.circle") else { return }
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        button.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        return button
    }()
    
    private let deleteButtonView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let createHabbitButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let titleAtributedString = NSAttributedString(string: "Создать",
                                                      attributes: titleAttribute)
        button.tintColor = .white
        button.setAttributedTitle(titleAtributedString, for: .normal)
        button.addTarget(self, action: #selector(createIrregularEvent), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1).cgColor
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let titleAtributedString = NSAttributedString(string: "Отменить",
                                                      attributes: titleAttribute)
        button.setAttributedTitle(titleAtributedString, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonDidTapped), for: .touchUpInside)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let categoryTableView: UITableView = {
       let tableView = UITableView()
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.register(NewHabbitCell.self, forCellReuseIdentifier: NewHabbitCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
        return tableView
    }()
    
    private let emojiCollectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 14
        layout.minimumLineSpacing = 25
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
        collection.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collection.register(EmojiSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojiSupplementaryView.identifier)
        collection.backgroundColor = .clear
        collection.isScrollEnabled = false
        return collection
    }()
    
    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 17
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collection.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collection.register(ColorSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ColorSupplementaryView.identifier)
        collection.isScrollEnabled = false
        collection.backgroundColor = .clear
        return collection
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
    
    @objc func cancelButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc func createIrregularEvent() {
     print("WWW")
    }

    
    @objc func deleteButtonDidTapped() {
        irregularNameTextField.text = ""
        
    }
    func setTextField() {
        irregularNameTextField.delegate = self
    }
    
    func configureEmojiCollection(with collectionView: UICollectionView, and emoji: [String]) {
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
    }
    
    func configureColorCollection(with collectionView: UICollectionView, and color: [Colors]) {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
    }
    
    func setConfiguration() {
        configureColorCollection(with: colorCollectionView, and: Colors.colors)
        configureEmojiCollection(with: emojiCollectionView, and: Emojis.emojis)
    }
    
    func configureTableView() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
}
extension IrregularEventViewController {
    private func showDeleteButton() {
        deleteButtonView.isHidden = false
        deleteButton.isHidden = false
    }
    private func moveViewUp(by amount: CGFloat) {
        textLimitLabel.isHidden = false
        categoryTableView.frame.origin.y += amount
        emojiCollectionView.frame.origin.y += amount
        colorCollectionView.frame.origin.y += amount
        lowStackView.frame.origin.y += amount
        scrollView.contentSize.height += amount
        
        isShifted = true
    }
    
    private func moveViewDown(by amount: CGFloat) {
        textLimitLabel.isHidden = true
        categoryTableView.frame.origin.y -= amount
        emojiCollectionView.frame.origin.y -= amount
        colorCollectionView.frame.origin.y -= amount
        lowStackView.frame.origin.y -= amount
        scrollView.contentSize.height -= amount
        
        isShifted = false
    }
    
    private func setupView() {
        view.backgroundColor = .white
        constraintsForView()
        configureTableView()
        setConfiguration()
        setTextField()
    }
    
    private func constraintsForView() {
        view.addSubview(scrollView)
        scrollView.addSubview(irregularEventLabel)
        scrollView.addSubview(irregularNameTextField)
        scrollView.addSubview(textLimitLabel)
        scrollView.addSubview(categoryTableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(lowStackView)
        scrollView.addSubview(deleteButtonView)
        deleteButtonView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            irregularEventLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 38),
            irregularEventLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            irregularEventLabel.widthAnchor.constraint(equalToConstant: 244),
            irregularEventLabel.heightAnchor.constraint(equalToConstant: 22),
            
            irregularNameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 110),
            irregularNameTextField.centerXAnchor.constraint(equalTo: irregularEventLabel.centerXAnchor),
            irregularNameTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            irregularNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            deleteButtonView.leadingAnchor.constraint(equalTo: irregularNameTextField.trailingAnchor, constant: -41),
            deleteButtonView.trailingAnchor.constraint(equalTo: irregularNameTextField.trailingAnchor),
            deleteButtonView.topAnchor.constraint(equalTo: irregularNameTextField.topAnchor),
            deleteButtonView.bottomAnchor.constraint(equalTo: irregularNameTextField.bottomAnchor),
            deleteButtonView.widthAnchor.constraint(equalToConstant: 41),
            
            deleteButton.centerYAnchor.constraint(equalTo: irregularNameTextField.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: irregularNameTextField.trailingAnchor, constant: -12),
            deleteButton.widthAnchor.constraint(equalToConstant: 17),
            deleteButton.heightAnchor.constraint(equalToConstant: 17),
            
            textLimitLabel.topAnchor.constraint(equalTo: irregularNameTextField.bottomAnchor, constant: 8),
            textLimitLabel.centerXAnchor.constraint(equalTo: irregularEventLabel.centerXAnchor),
            textLimitLabel.widthAnchor.constraint(equalToConstant: 286),
            textLimitLabel.heightAnchor.constraint(equalTo: irregularEventLabel.heightAnchor),
            
            categoryTableView.topAnchor.constraint(equalTo: irregularNameTextField.bottomAnchor, constant: 24),
            categoryTableView.centerXAnchor.constraint(equalTo: irregularNameTextField.centerXAnchor),
            categoryTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            categoryTableView.heightAnchor.constraint(equalToConstant: 75),
            
            emojiCollectionView.topAnchor.constraint(equalTo: categoryTableView.bottomAnchor, constant: 32),
            emojiCollectionView.centerXAnchor.constraint(equalTo: categoryTableView.centerXAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 220),
            emojiCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 42),
            colorCollectionView.centerXAnchor.constraint(equalTo: emojiCollectionView.centerXAnchor),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 220),
            colorCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            lowStackView.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 46),
            lowStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            lowStackView.heightAnchor.constraint(equalToConstant: 60),
            lowStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 161),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            
            createHabbitButton.widthAnchor.constraint(equalToConstant: 161),
            createHabbitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
    }
}

extension IrregularEventViewController: UITextFieldDelegate {
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

extension IrregularEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case emojiCollectionView:
           guard let selectedEmojiCell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { fatalError("Couldn't choose Emoji")}
            selectedEmojiCell.emojiBackgroundView.isHidden = false
            selectedEmojiIndexPath = indexPath
            selectedEmoji = selectedEmojiCell.titleLabel.text
            
            if let previousSelected = selectedEmojiIndexPath {
                if let previousSelectedCell = collectionView.cellForItem(at: previousSelected) as? EmojiCell {
                    previousSelectedCell.emojiBackgroundView.isHidden = true
                }
            }
        case colorCollectionView:
            guard let selectedColorCell = collectionView.cellForItem(at: indexPath) as? ColorCell else {
                fatalError("Couldn't choose Color") }
            selectedColorCell.colorBackgroundView.isHidden = false
            selectedColorIndexPath = indexPath
            selectedColor = Colors.colors[indexPath.row].color
            
            if let previousSelected = selectedColorIndexPath {
                if let previousSelectedCell = collectionView.cellForItem(at: previousSelected) as? ColorCell {
                    previousSelectedCell.colorBackgroundView.isHidden = true
                }
            }
        default: break
        }
    }
}

extension IrregularEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case emojiCollectionView:
            guard let emojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else { fatalError() }
            return emojiCell.calculateEmojiCell(collectionView: emojiCollectionView)
        case colorCollectionView:
            guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { fatalError() }
            return colorCell.calculateColorCell(collectionView: colorCollectionView)
        default: break
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension IrregularEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard collectionView == emojiCollectionView else { return Colors.count }
        return Emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else { fatalError() }
            let index = Emojis.count % indexPath.row
            let emoji = Emojis[index]
            cell.titleLabel.text = emoji
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { fatalError() }
            let index = Colors.count % indexPath.row
            let color = Colors.colors[index]
            cell.configureCell(with: color.color)
            return cell
        }
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
            
            colorView.titleLabel.text = "Цвет"
            return colorView
        }
        guard let emojiView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? EmojiSupplementaryView else { return UICollectionReusableView() }
        emojiView.titleLabel.text = "Emoji"
        return emojiView
    }
    
}



extension IrregularEventViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryViewInset.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewHabbitCell.identifier, for: indexPath) as? NewHabbitCell else { return UITableViewCell() }
        let text = categoryViewInset[indexPath.row]
        let image = cell.iconImageView.image
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        cell.layer.masksToBounds = true
        cell.configureCell(with: text, and: image)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categories = CategoriesViewController()
        categories.delegate = self
        self.present(categories, animated: true)
    }
    
}

extension IrregularEventViewController: CategoriesDelegate {
    func didSelectCategory(_ selectedCategory: TrackerCategory) {
        self.selectedCategory = selectedCategory
        
        guard let cell = categoryTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? NewHabbitCell else { fatalError() }
        cell.subLabel.text = selectedCategory.categoryName
        cell.moveLabel()
    }
    
    
}