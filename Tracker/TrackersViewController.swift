import UIKit

final class TrackersViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundView = UIImageView(image: UIImage(named: "1"))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let trackerLabel: UILabel = {
        let trackerLabel = UILabel()
        trackerLabel.text = "Трекеры"
        trackerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        trackerLabel.tintColor = .black
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerLabel
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let trackers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigation()
        constraintsForTrackerView()
        constraintsForSearchBar()
    }

    @objc func addTracker() {
        let trackerCreator = TrackerCreatorViewController()
        self.present(trackerCreator, animated: true)
        
    }

    private func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = trackerLabel
      
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addTracker), for: .touchUpInside)
        addButton.tintColor = .black
        addButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let addButtonBarItem = UIBarButtonItem(customView: addButton)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        view.addSubview(datePicker)
        let dateBarButtonPicker = UIBarButtonItem(customView: datePicker)
        
        navigationItem.leftBarButtonItem = addButtonBarItem
        navigationItem.rightBarButtonItem = dateBarButtonPicker
        
        if let addButtonView = addButtonBarItem.customView,
           let datePickerView = dateBarButtonPicker.customView {
            view.addSubview(addButtonView)
            addButtonView.translatesAutoresizingMaskIntoConstraints = false
            datePickerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                datePickerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 97),
                datePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21.5),
                datePickerView.heightAnchor.constraint(equalToConstant: 34),
                datePickerView.widthAnchor.constraint(equalToConstant: 77),
                addButtonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
                addButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
                addButtonView.heightAnchor.constraint(equalToConstant: 20),
                addButtonView.widthAnchor.constraint(equalToConstant: 20)
            ])
        }
        
    }
    
    private func constraintsForTrackerView() {
        view.addSubview(trackerLabel)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            trackerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            trackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            trackerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -105),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 146),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func constraintsForSearchBar() {
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 134),
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackersViewCell
         return cell!
    }
    
    
}

extension TrackersViewController: UICollectionViewDelegate {
    
}
