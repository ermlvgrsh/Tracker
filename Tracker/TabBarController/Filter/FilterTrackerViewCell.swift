import UIKit


final class FilterTrackerViewCell: UITableViewCell {
    
    static let identifer = "FilterCell"
    
    let doneImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "checkmark"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isHidden = true
        return iv
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureCell(with text: String?) {
        self.filterLabel.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(filterLabel)
        addSubview(doneImageView)
        
        NSLayoutConstraint.activate([
            filterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            filterLabel.widthAnchor.constraint(equalToConstant: 286),
            filterLabel.heightAnchor.constraint(equalToConstant: 22),
            
            doneImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            doneImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            doneImageView.widthAnchor.constraint(equalToConstant: 14),
            doneImageView.heightAnchor.constraint(equalToConstant: 14)
            
        ])
    }
}
