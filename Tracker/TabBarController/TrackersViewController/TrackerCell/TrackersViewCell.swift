import UIKit
protocol TrackerViewCellDelegate: AnyObject {
    func doneButtonDidTapped(for cell: TrackersViewCell)
    func doneButtonUntapped(for cell: TrackersViewCell)
 
}

class TrackersViewCell: UICollectionViewCell {

    static let identifier = "TrackerViewCell"
    var dayCounter = 0
    private let isCompleted = false
    weak var delegate: TrackerViewCellDelegate? 
    var trackerID: UUID?
    
    let trackerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 167, height: 90))
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emoji: UILabel = {
        let emoji = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        emoji.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emoji.textAlignment = .center
        emoji.translatesAutoresizingMaskIntoConstraints = false
        return emoji
    }()
    
    let emojiBackgroundView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let trackerName: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 143, height: 34))
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let daysCounter: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 101, height: 18))
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        label.textAlignment = .left
        label.text = "0 дней"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        let circleImage = UIImage(named: "1plus")?.withRenderingMode(.alwaysTemplate)
        button.setImage(circleImage, for: .normal)
        button.addTarget(self, action: #selector(addDayToHabbit), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        return button
    }()

    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Done"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(removeDayToHabbit), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    
    let backgroundViewDone: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 17
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    func updateDayCounterLabel() {
        let dayCounterText: String
        switch dayCounter {
        case 0:
            dayCounterText = "0 дней"
        case 1:
            dayCounterText = "1 день"
        case 2, 3, 4:
            dayCounterText = "\(dayCounter) дня"
        case let count where count >= 5:
            dayCounterText = "\(dayCounter) дней"
        default:
            dayCounterText = "\(dayCounter) дней"
        }
        daysCounter.text = dayCounterText
    }

    @objc func addDayToHabbit() {
        guard let delegate = delegate else { return }
        delegate.doneButtonDidTapped(for: self)
    }
    
    @objc func removeDayToHabbit() {
        guard let delegate = delegate else { return }
        delegate.doneButtonUntapped(for: self)
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        constraintsForCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func constraintsForCell() {
        contentView.addSubview(trackerView)
        contentView.addSubview(daysCounter)
        contentView.addSubview(plusButton)
        contentView.addSubview(doneButton)
        contentView.addSubview(backgroundViewDone)
        backgroundViewDone.addSubview(doneButton)
        trackerView.addSubview(emoji)
        trackerView.addSubview(trackerName)
        trackerView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emoji)
        
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            trackerView.topAnchor.constraint(equalTo: topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.widthAnchor.constraint(equalToConstant: 167),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackgroundView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            
            emoji.topAnchor.constraint(equalTo: emojiBackgroundView.topAnchor),
            emoji.leadingAnchor.constraint(equalTo: emojiBackgroundView.leadingAnchor),
            emoji.trailingAnchor.constraint(equalTo: emojiBackgroundView.trailingAnchor),
            emoji.bottomAnchor.constraint(equalTo: emojiBackgroundView.bottomAnchor),

            
            trackerName.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 44),
            trackerName.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerName.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            trackerName.widthAnchor.constraint(equalToConstant: 143),
            trackerName.heightAnchor.constraint(equalToConstant: 34),
            
            daysCounter.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 16),
            daysCounter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCounter.widthAnchor.constraint(equalToConstant: 101),
            daysCounter.heightAnchor.constraint(equalToConstant: 18),
            
            plusButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            plusButton.leadingAnchor.constraint(equalTo: daysCounter.trailingAnchor, constant: 8),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            
            backgroundViewDone.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: 8),
            backgroundViewDone.leadingAnchor.constraint(equalTo: daysCounter.trailingAnchor, constant: 8),
            backgroundViewDone.widthAnchor.constraint(equalToConstant: 34),
            backgroundViewDone.heightAnchor.constraint(equalToConstant: 34),
            
            doneButton.centerYAnchor.constraint(equalTo: backgroundViewDone.centerYAnchor),
            doneButton.centerXAnchor.constraint(equalTo: backgroundViewDone.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 12),
            doneButton.heightAnchor.constraint(equalToConstant: 12),
            
        ])
    }
    
    func configureCell(with trackerName: String, color: UIColor, emoji: String) {
        trackerView.layer.backgroundColor = color.cgColor
        plusButton.tintColor = color
        self.trackerName.text = trackerName
        self.emoji.text = emoji
        self.backgroundViewDone.layer.backgroundColor = color.cgColor
        updateDayCounterLabel()
    }
}


extension TrackersViewCell {
    
    func animateButtonWithTransition(previousButton: UIButton, to newButton: UIButton, completion: @escaping () -> Void) {
        
        UIView.animate(withDuration: 0.3, animations: {
            previousButton.alpha = 0
            newButton.alpha = 1
        }) { (_) in
            previousButton.isHidden = true
            newButton.isHidden = false
            completion()
        }
    }
}

