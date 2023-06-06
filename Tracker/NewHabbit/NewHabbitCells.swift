import UIKit

class NewHabbitCell: UITableViewCell {
    
    static let identifier = "NewHabbitCell"
    
    let iconImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "Icon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
     let mainLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureCell(with text: String?, and image: UIImage?) {
        self.mainLabel.text = text
        self.iconImageView.image = image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()

    func setUI() {
 
        contentView.addSubview(mainLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subLabel)
        NSLayoutConstraint.activate([
            
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            mainLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
            mainLabel.widthAnchor.constraint(equalToConstant: 271),
            mainLabel.heightAnchor.constraint(equalToConstant: 22),
            
            subLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 2),
            subLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor),
            subLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor),
            subLabel.widthAnchor.constraint(equalToConstant: 271),
            subLabel.heightAnchor.constraint(equalToConstant: 22),

            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            iconImageView.widthAnchor.constraint(equalToConstant: 7),
            iconImageView.heightAnchor.constraint(equalToConstant: 12)
            
        ])
    }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func moveLabel() {
        mainLabel.transform = CGAffineTransform(translationX: 0, y: -12)
        subLabel.transform = CGAffineTransform(translationX: 0, y: -12)
        subLabel.isHidden = false
    }
}
