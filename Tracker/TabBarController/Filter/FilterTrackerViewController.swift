import UIKit

final class FilterTrackerViewController: UIViewController {
   
    private lazy var filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.register(FilterTrackerViewCell.self, forCellReuseIdentifier: FilterTrackerViewCell.identifer)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tableView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let tableViewInsets = ["all_trackers".localized,
                                   "trackers_for_today".localized,
                                   "complete_trackers".localized,
                                   "incompleted_trackers".localized]
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.backgroundColor = .white
        label.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        label.attributedText =
        NSMutableAttributedString(string: "filters".localized,
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func configureTableView() {
        filterTableView.delegate = self
        filterTableView.dataSource = self
    }
    
    
    func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(filterTableView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 72),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            filterTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            filterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterTableView.heightAnchor.constraint(equalToConstant: 300),
            filterTableView.widthAnchor.constraint(equalToConstant: 343)
        
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupUI()
    }
}


extension FilterTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0,
                                               left: tableView.bounds.size.width,
                                               bottom: 0,
                                               right: 0)
        }
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath) as? FilterTrackerViewCell {
            selectedCell.doneImageView.isHidden = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension FilterTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewInsets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTrackerViewCell.identifer, for: indexPath) as? FilterTrackerViewCell else { return UITableViewCell() }
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        cell.layer.masksToBounds = true
        let text = tableViewInsets[indexPath.row]
        cell.configureCell(with: text)
        return cell
    }
}
