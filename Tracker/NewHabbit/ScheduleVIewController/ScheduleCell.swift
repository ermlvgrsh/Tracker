import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func switchValueDidChanged(for cell: ScheduleCell, isOn: Bool)
}


class ScheduleCell: UITableViewCell {
    
    weak var delegate: ScheduleCellDelegate?
    
    static let identifier = "Schedule"
    var weekDays: [WeekDay] {
        return WeekDay.allCases
    }
    var selectedDay: WeekDay?
    
    lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = UIColor(red: 0.216, green: 0.447, blue: 0.906, alpha: 1)
        switcher.thumbTintColor = .white
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addTarget(self, action: #selector(switchHandler(_:)), for: .valueChanged)
        return switcher
    }()
    
    @objc func switchHandler(_ switcher: UISwitch) {
        let isOn = switcher.isOn
        delegate?.switchValueDidChanged(for: self, isOn: isOn)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureCell(with weekDay: WeekDay) {
        switch weekDay {
        case .Monday:
            self.titleLabel.text = "monday".localized
        case .Tuesday:
            self.titleLabel.text = "tuesday".localized
        case .Wednesday:
            self.titleLabel.text = "wednesday".localized
        case .Thursday:
            self.titleLabel.text = "thursday".localized
        case .Friday:
            self.titleLabel.text = "friday".localized
        case .Saturday:
            self.titleLabel.text = "saturday".localized
        case .Sunday:
            self.titleLabel.text = "sunday".localized
        }
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(switcher)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 271),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switcher.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
            switcher.widthAnchor.constraint(equalToConstant: 51),
            switcher.heightAnchor.constraint(equalToConstant: 31),
            
        ])
    }
}
