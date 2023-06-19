import UIKit

class TrackersViewCell: UICollectionViewCell {
    
    static let identifier = "TrackerViewCell"
    
    let trackerView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: 167, height: 90))
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emoji: UILabel = {
        let emoji = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
        emoji.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        emoji.textAlignment = .center
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        view.layer.masksToBounds = true
        view.isHidden = true
        view.layer.cornerRadius = 68
        view.translatesAutoresizingMaskIntoConstraints = false
        
        emoji.addSubview(view)
        
        NSLayoutConstraint.activate([
            emoji.topAnchor.constraint(equalTo: view.topAnchor),
            emoji.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emoji.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emoji.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return emoji
    }()
    
    let trackerName: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 143, height: 34))
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let daysCounter: UILabel = {
       let label = UILabel(frame: CGRect(x: 0, y: 0, width: 101, height: 18))
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        label.textAlignment = .left
        label.text = "0 days"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let plusButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "1plus"), for: .normal)
        button.addTarget(TrackersViewController.self, action: #selector(addDayToHabbit), for: .touchUpInside)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        return button
    }()
    
    let doneButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "Done"), for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.alpha = 0.3
        button.layer.borderWidth = 1
        button.isHidden = true
        return button
    }()
    
    @objc func addDayToHabbit() {
        plusButton.isHidden = true
        doneButton.isHidden = false
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
        trackerView.addSubview(emoji)
        trackerView.addSubview(trackerName)
        contentView.addSubview(daysCounter)
        contentView.addSubview(plusButton)
        contentView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            trackerView.widthAnchor.constraint(equalToConstant: 167),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            emoji.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 13),
            emoji.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 16),
            emoji.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -135),
            emoji.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -55),
            emoji.heightAnchor.constraint(equalToConstant: 20),
            emoji.widthAnchor.constraint(equalToConstant: 16),
            
            trackerName.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 44),
            trackerName.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            trackerName.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            trackerName.widthAnchor.constraint(equalToConstant: 143),
            trackerName.heightAnchor.constraint(equalToConstant: 34),
            
            daysCounter.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -16),
            daysCounter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            daysCounter.widthAnchor.constraint(equalToConstant: 101),
            daysCounter.heightAnchor.constraint(equalToConstant: 18),
            
            plusButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -8),
            plusButton.leadingAnchor.constraint(equalTo: daysCounter.trailingAnchor, constant: 8),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
            
            doneButton.topAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -8),
            doneButton.leadingAnchor.constraint(equalTo: daysCounter.trailingAnchor, constant: 8),
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            
        ])
    }
    
    func configureCell(with trackerName: String, color: UIColor, emoji: String) {
        trackerView.layer.backgroundColor = color.cgColor
        plusButton.layer.backgroundColor = color.cgColor
        self.trackerName.text = trackerName
        self.emoji.text = emoji
        
    }
}
