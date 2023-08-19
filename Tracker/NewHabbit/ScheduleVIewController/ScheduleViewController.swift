import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didSetSchedule(for weekDays: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    let weekDays = ScheduleCell().weekDays.count
    var selectedSchedule: [WeekDay?] = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scheduleLabel: UILabel = {
        let habbitLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 133, height: 22))
        habbitLabel.font = .systemFont(ofSize: 16, weight: .medium)
        habbitLabel.backgroundColor = .white
        habbitLabel.textAlignment = .center
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.15
        habbitLabel.attributedText =
        NSMutableAttributedString(string: "Расписание",
                                  attributes: [NSAttributedString.Key.paragraphStyle : paragraphStyle])
        habbitLabel.translatesAutoresizingMaskIntoConstraints = false
        return habbitLabel
    }()
    
    private let scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .white
        tableView.rowHeight = 75
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.separatorColor = .darkGray
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 335, height: 60)
        button.backgroundColor = .white
        button.layer.backgroundColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
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
    
    @objc func doneButtonTapped() {
        delegate?.didSetSchedule(for: selectedSchedule.compactMap{ $0 })
        dismiss(animated: true)
    }
    
    func setupUI() {
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        view.addSubview(scrollView)
        
        scrollView.addSubview(scheduleLabel)
        scrollView.addSubview(scheduleTableView)
        scrollView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            
        scrollView.topAnchor.constraint(equalTo: view.topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        scheduleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
        scheduleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        scheduleLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -712),
        scheduleLabel.widthAnchor.constraint(equalToConstant: 97),
        scheduleLabel.heightAnchor.constraint(equalToConstant: 22),
        
        scheduleTableView.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 30),
        scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        scheduleTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -149),
        
        doneButton.topAnchor.constraint(equalTo: scheduleTableView.bottomAnchor, constant: 39),
        doneButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        doneButton.widthAnchor.constraint(equalToConstant: 335),
        doneButton.heightAnchor.constraint(equalToConstant: 60)
        
        ])
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier, for: indexPath) as? ScheduleCell else { return UITableViewCell() }
        let weekDay = cell.weekDays[indexPath.row]
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        cell.delegate = self
        cell.configureCell(with: weekDay)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.size.width, bottom: 0, right: 0)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scheduleTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ScheduleViewController: ScheduleCellDelegate {
    func switchValueDidChanged(for cell: ScheduleCell, isOn: Bool) {
        guard let indexPath = scheduleTableView.indexPath(for: cell) else { fatalError() }
        let selectedDay = cell.weekDays[indexPath.row]
        if isOn {
            selectedSchedule.append(selectedDay)
        } else {
            if let index = selectedSchedule.firstIndex(of: selectedDay) {
                selectedSchedule.remove(at: index)
            }
        }
    }
}

