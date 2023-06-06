import UIKit

class ColorCell: UICollectionViewCell {
    
     static let identifier = "ColorCell"
    
    let colorView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
   
    func setupCell() {
         contentView.addSubview(colorView)
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40)
        ])
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with color: UIColor) {
        colorView.backgroundColor = color
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
