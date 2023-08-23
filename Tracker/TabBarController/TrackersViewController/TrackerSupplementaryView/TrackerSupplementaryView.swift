import UIKit

class TrackerSupplementaryView: UICollectionReusableView {
    
    static let identifier = "header"
    
    let categoryLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 149, height: 18))
        label.backgroundColor = .systemBackground
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -198),
            categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
