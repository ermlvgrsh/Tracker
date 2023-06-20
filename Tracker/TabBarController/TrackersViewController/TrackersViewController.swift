import UIKit

final class TrackersViewController: UIViewController {
    
    
    var currentDate: Date = Date() {
        didSet {
            updateTrackers()
        }
    }
    
    var trackers: [Tracker] = []
    
    var trackersCategory: [TrackerCategory] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: TrackersViewCell.identifier)
        collectionView.register(TrackerSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerSupplementaryView.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let placeholderImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        paragraphStyle.alignment = .center
        label.attributedText =
        NSMutableAttributedString(string: "Что будем отслеживать?", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "Трекеры"
        trackerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerLabel.tintColor = .black
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    private let searchBar: UISearchTextField = {
        let searchBar = UISearchTextField()
        searchBar.placeholder = "Поиск"
        searchBar.layer.masksToBounds = true
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        searchBar.rightView = cancelButton
        searchBar.rightViewMode = .whileEditing
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        searchBar.layer.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12).cgColor
        searchBar.layer.cornerRadius = 8
        return searchBar
    }()
    
    @objc func cancelButtonTapped() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintsForTrackerView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTrackers()
    }
    
    @objc func addTracker() {
        let trackerCreator = TrackerCreatorViewController()
        trackerCreator.delegate = self
        self.present(trackerCreator, animated: true)
        
    }
    
    private func configureCollectionView() {
   
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func constraintsForTrackerView() {
        view.backgroundColor = .white
        
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        addButton.tintColor = .black
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let addButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        addButtonView.translatesAutoresizingMaskIntoConstraints = false
        addButtonView.addSubview(addButton)
        let buttonItem = UIBarButtonItem(customView: addButtonView)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueDidChanged), for: .touchUpInside)
        let datePickerView = UIView(frame: CGRect(x: 0, y: 0, width: 77, height: 34))
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.addSubview(datePicker)
        let dateItem = UIBarButtonItem(customView: datePickerView)
        
        
        navigationItem.leftBarButtonItem = buttonItem
        navigationItem.rightBarButtonItem = dateItem
        
        navigationController?.navigationBar.topItem?.leftBarButtonItems = navigationItem.leftBarButtonItems
        navigationController?.navigationBar.topItem?.rightBarButtonItems = navigationItem.rightBarButtonItems

        view.addSubview(datePickerView)
        view.addSubview(addButtonView)
        view.addSubview(collectionView)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        view.addSubview(searchBar)
        view.addSubview(trackerLabel)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerView.bottomAnchor),
            
            addButton.topAnchor.constraint(equalTo: addButtonView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: addButtonView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: addButtonView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: addButtonView.bottomAnchor),
            
            datePickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 91),
            datePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 282),
            datePickerView.heightAnchor.constraint(equalToConstant: 34),
            datePickerView.widthAnchor.constraint(equalToConstant: 77),
            
            addButtonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            addButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            addButtonView.heightAnchor.constraint(equalToConstant: 18),
            addButtonView.widthAnchor.constraint(equalToConstant: 18),
            
            
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            trackerLabel.widthAnchor.constraint(equalToConstant: 254),
            trackerLabel.heightAnchor.constraint(equalToConstant: 41),
            trackerLabel.trailingAnchor.constraint(equalTo: datePickerView.leadingAnchor, constant: -12),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 64),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            placeholderImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 402),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            placeholderLabel.widthAnchor.constraint(equalToConstant: 343),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 18),
            
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.widthAnchor.constraint(equalToConstant: 343),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    @objc func datePickerValueDidChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
    func updateTrackers() {
        let currentDay = Calendar.current
        let currentWeekday = currentDay.component(.weekday, from: currentDate)
        let currentWeekdayString = WeekDay.allCases[currentWeekday].rawValue
        
        guard let currentWeekDayEnum = WeekDay(rawValue: currentWeekdayString) else { return }
        let filteredTrackers = trackers.filter { tracker in
            return tracker.schedule.contains(currentWeekDayEnum)
        }
        
    }
}


extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersViewCell.identifier, for: indexPath) as? TrackersViewCell else { fatalError("Unable to dequeue TrackersViewCell") }
        let tracker = trackers[indexPath.row]
        cell.configureCell(with: tracker.name, color: tracker.color, emoji: tracker.emoji)
         return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader: id = "header"
        case UICollectionView.elementKindSectionFooter: id = "footer"
        default: id = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackerSupplementaryView else { return UICollectionReusableView() }
        view.categoryLabel.text = trackersCategory[indexPath.row].categoryName
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let headerWidth = collectionView.bounds.width - padding
        let widthPerItem = headerWidth / 2 - padding
        return CGSize(width: widthPerItem, height: 50)
    }

}

extension TrackersViewController: UISearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButtonToKeyboard()
    }
    
}
extension TrackersViewController: NewTrackerDelegate {
    func didCreateTracker(newTracker: Tracker, with category: TrackerCategory) {
        placeholderImage.isHidden = true
        placeholderLabel.isHidden = true
        trackersCategory.append(category)
        trackers.append(newTracker)
        configureCollectionView()
        collectionView.reloadData()
    }
    


}


