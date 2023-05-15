import UIKit

class ScheduleCell: UITableViewCell {
    
    static let identifier = "Schedule"
    var weekDays: [WeekDay] {
        return WeekDay.allCases
    }
    
    var selectedDay: WeekDay?
    var schedule = ButtonCell().subLabel.text
    
    enum WeekDay: String, CaseIterable {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
        
    }
   
    let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = false
        switcher.onTintColor = UIColor(red: 0.216, green: 0.447, blue: 0.906, alpha: 1)
        switcher.thumbTintColor = .white
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addTarget(self, action: #selector(switchHandler(_:)), for: .valueChanged)
        return switcher
    }()
    
    @objc func switchHandler(_ switcher: UISwitch) {
        if switcher.isOn {
            if let selectedDay = self.selectedDay {
                self.schedule = self.shortName(weekDay: selectedDay)
            }
        }
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
            self.titleLabel.text = "Понедельник"
        case .Tuesday:
            self.titleLabel.text = "Вторник"
        case .Wednesday:
            self.titleLabel.text = "Среда"
        case .Thursday:
            self.titleLabel.text = "Четверг"
        case .Friday:
            self.titleLabel.text = "Пятница"
        case .Saturday:
            self.titleLabel.text = "Суббота"
        case .Sunday:
            self.titleLabel.text = "Воскресенье"
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
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
        titleLabel.widthAnchor.constraint(equalToConstant: 271),
        titleLabel.heightAnchor.constraint(equalToConstant: 22),
        
        switcher.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22),
        switcher.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 276),
        switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        switcher.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
        switcher.widthAnchor.constraint(equalToConstant: 51),
        switcher.heightAnchor.constraint(equalToConstant: 31),
        
        contentView.widthAnchor.constraint(equalToConstant: 343),
        contentView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func shortName(weekDay: WeekDay) -> String {
       switch weekDay {
        case .Monday:
            return "Пн"
        case .Tuesday:
            return "Вт"
        case .Wednesday:
            return "Ср"
        case .Thursday:
            return "Чт"
        case .Friday:
            return "Пт"
        case .Saturday:
            return "Сб"
        case .Sunday:
            return "Вс"
        }
    }
}
