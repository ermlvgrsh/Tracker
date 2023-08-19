import UIKit

class ColorCell: UICollectionViewCell {
    
    static let identifier = "ColorCell"
    
    let colorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        
        let whiteStroke = UIView()
        whiteStroke.translatesAutoresizingMaskIntoConstraints = false
        whiteStroke.layer.masksToBounds = true
        whiteStroke.layer.cornerRadius = 8
        whiteStroke.layer.borderWidth = 3
        whiteStroke.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        
        view.addSubview(whiteStroke)
        NSLayoutConstraint.activate([
            whiteStroke.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            whiteStroke.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            whiteStroke.heightAnchor.constraint(equalToConstant: 46),
            whiteStroke.widthAnchor.constraint(equalToConstant: 46)
        ])
        return view
    }()
    
    let colorBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.alpha = 0.3
        view.layer.borderWidth = 3
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        contentView.addSubview(colorBackgroundView)
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: topAnchor),
            colorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            colorBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            colorBackgroundView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with color: UIColor) {
        colorView.backgroundColor = color
        colorBackgroundView.layer.borderColor = color.cgColor
    }
    
}

extension ColorCell {
    
    func calculateColorCell(collectionView: UICollectionView) -> CGSize {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Unable to calculate colorCell size!")
        }
        
        let horizontalPadding: CGFloat = 17
        let itemsPerRow: CGFloat = 6
        let interItemSpacing = layout.minimumInteritemSpacing
        
        let totalHorizontalPadding = (horizontalPadding) + (interItemSpacing * (itemsPerRow - 1))
        let availableWidth = collectionView.bounds.width - totalHorizontalPadding
        
        let widthPerItem = availableWidth / itemsPerRow
        
        let aspectRatio: CGFloat = 1.0
        let heightPerItem = widthPerItem * aspectRatio
        
        let size = CGSize(width: widthPerItem, height: heightPerItem)
        return size
    }
    
    
}
