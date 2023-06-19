import UIKit


class EmojiSupplementaryView: UICollectionReusableView {
    let titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.79
        titleLabel.attributedText = NSMutableAttributedString(string: "Emoji", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    static let identifier = "header"
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -31)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ColorSupplementaryView: UICollectionReusableView {
    
    let titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.79
        titleLabel.attributedText = NSMutableAttributedString(string: "Color", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    static let identifier = "header"
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -31)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
