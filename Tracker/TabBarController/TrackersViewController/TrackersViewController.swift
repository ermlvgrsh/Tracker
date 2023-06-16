import UIKit

final class TrackersViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: TrackersViewCell.identifier)
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
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .white
        searchBar.layer.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12).cgColor
        searchBar.layer.cornerRadius = 8
        return searchBar
    }()
    
    let trackers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintsForTrackerView()
        configureCollectionView()
    }
    
    @objc func addTracker() {
        let trackerCreator = TrackerCreatorViewController()
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
        let datePickerView = UIView(frame: CGRect(x: 0, y: 0, width: 77, height: 34))
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        datePickerView.addSubview(datePicker)
        let dateItem = UIBarButtonItem(customView: datePickerView)
        
        
        navigationItem.leftBarButtonItem = buttonItem
        navigationItem.rightBarButtonItem = dateItem

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
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 146),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
}


extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackersViewCell else { return UICollectionViewCell() }
         return cell
    }
    
    
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

extension TrackersViewController: UISearchTextFieldDelegate {
    
    
}

