import UIKit

final class TrackersViewController: UIViewController {
    
    var currentDate = Date()
    
    var valueDatePicker: Date = Date() {
        didSet {
            updateTrackers()
        }
    }
    
    var trackers: [Tracker] = []
    
    var trackersCategory: [TrackerCategory] = []
    private var datePicker: UIDatePicker?
    private var datePickerView: UIView?
    private var addButtonView: UIView?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 0, right: 16)
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
    
    @objc func addTracker() {
        let trackerCreator = TrackerCreatorViewController()
        trackerCreator.delegate = self
        self.present(trackerCreator, animated: true)
        
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureAddButton() -> UIBarButtonItem? {
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        addButton.tintColor = .black
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        addButtonView = view
        addButtonView?.translatesAutoresizingMaskIntoConstraints = false
        addButtonView?.addSubview(addButton)
        guard let addButtonView = addButtonView else { return nil }
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: addButtonView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: addButtonView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: addButtonView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: addButtonView.bottomAnchor),
        ])
        let buttonItem = UIBarButtonItem(customView: addButtonView)
        return buttonItem
    }
    
    private func configureDatePicker() -> UIBarButtonItem? {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueDidChanged), for: .valueChanged)
        self.datePicker = datePicker
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 77, height: 34))
        datePickerView = view
        guard let datePickerView = datePickerView else { return nil}
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: datePickerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerView.bottomAnchor),
        ])
 
        let dateItem = UIBarButtonItem(customView: datePickerView)
        return dateItem
    }
    
    private func constraintsForTrackerView() {
        view.backgroundColor = .white
        searchBar.delegate = self
        
        let buttonItem = configureAddButton()
        let dateItem = configureDatePicker()
        
        navigationItem.leftBarButtonItem = buttonItem
        navigationItem.rightBarButtonItem = dateItem
        
        guard let datePickerView = datePickerView,
        let addButtonView = addButtonView else { return }
        
        view.addSubview(datePickerView)
        view.addSubview(addButtonView)
        view.addSubview(collectionView)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        view.addSubview(searchBar)
        view.addSubview(trackerLabel)
        
        NSLayoutConstraint.activate([

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
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
        valueDatePicker = sender.date
    }
    func updateTrackers() {
        let currentDay = Calendar.current
        let currentWeekday = currentDay.component(.weekday, from: valueDatePicker)
        
        guard let currentWeekDayEnum = WeekDay(rawValue: currentWeekday)
        else { return }
        let filteredTrackers = trackers.filter { tracker in
            return tracker.schedule.contains(currentWeekDayEnum)
        }
        trackers = filteredTrackers

        if filteredTrackers.isEmpty {
            placeholderImage.isHidden = false
            placeholderLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            placeholderImage.isHidden = true
            placeholderLabel.isHidden = true
            collectionView.reloadData()
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
        cell.delegate = self
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
        return CGSize(width: collectionView.frame.width, height: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 41) / 2
        let height = width * 0.8
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}

extension TrackersViewController: UISearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addDoneButtonToKeyboard()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = searchBar.text else { return }
        let filteredTrackers = trackers.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        trackers = filteredTrackers
        collectionView.reloadData()
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


extension TrackersViewController: TrackerViewCellDelegate {
    func dateValueDidChanged() -> Bool {
       return currentDate > valueDatePicker
    }
}
