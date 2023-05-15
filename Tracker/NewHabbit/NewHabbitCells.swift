import UIKit

class ButtonCell: UITableViewCell {
    
    static let identifier = "ButtonCell"
    
    let myImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "Icon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
     let myLabel: UILabel = {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureCell(with text: String?, and image: UIImage?) {
        self.myLabel.text = text
        self.myImageView.image = image
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()

    func setUI() {
 
        contentView.addSubview(myLabel)
        contentView.addSubview(myImageView)
        contentView.addSubview(subLabel)
        NSLayoutConstraint.activate([
            
            myLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            myLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            myLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            myLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
            myLabel.widthAnchor.constraint(equalToConstant: 271),
            myLabel.heightAnchor.constraint(equalToConstant: 22),
            
            subLabel.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 2),
            subLabel.leadingAnchor.constraint(equalTo: myLabel.leadingAnchor),
            subLabel.trailingAnchor.constraint(equalTo: myLabel.trailingAnchor),
            subLabel.widthAnchor.constraint(equalToConstant: 271),
            subLabel.heightAnchor.constraint(equalToConstant: 22),

            myImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            myImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -31),
            myImageView.widthAnchor.constraint(equalToConstant: 7),
            myImageView.heightAnchor.constraint(equalToConstant: 12)
            
        ])
    }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
