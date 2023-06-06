import UIKit

class CategoryCell: UITableViewCell {
    
   static let identifier = "CategoryCell"
    
    var isChecked: Bool = false {
        didSet {
            checkmarkImage.isHidden = !isChecked
        }
    }
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: .regular)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.08
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkmarkImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "checkmark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func cellTapped() {
    isChecked = !isChecked
        
    }
    
    func setUI() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(checkmarkImage)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
//        contentView.addGestureRecognizer(tapGesture)
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryLabel.widthAnchor.constraint(equalToConstant: 286),
            
            checkmarkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -36),
            checkmarkImage.widthAnchor.constraint(equalToConstant: 14),
            checkmarkImage.heightAnchor.constraint(equalToConstant: 14),
        
        ])
    }
}

    
