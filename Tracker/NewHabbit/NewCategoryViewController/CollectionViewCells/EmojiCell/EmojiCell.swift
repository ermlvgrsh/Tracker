import UIKit

class EmojiCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    let emojiBackgroundView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))
        view.layer.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 1).cgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    static let identifier = "Emoji"
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiBackgroundView) // Add emojiBackgroundView as a subview
           
           // Set constraints for emojiBackgroundView
           emojiBackgroundView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               emojiBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
               emojiBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
               emojiBackgroundView.widthAnchor.constraint(equalToConstant: 52),
               //emojiBackgroundView.heightAnchor.constraint(equalToConstant: 52)
           ])
           
           contentView.addSubview(titleLabel) // Add titleLabel as a subview
           
           // Set constraints for titleLabel
           titleLabel.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 32),
            titleLabel.heightAnchor.constraint(equalToConstant: 38)
           ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension EmojiCell {
    func calculateEmojiCell(collectionView: UICollectionView) -> CGSize {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else
        { fatalError("Unable to calculate colorCell size!") }
        
        let horizontalPadding: CGFloat = 25
        let itemsPerRow: CGFloat = 6
        let interItemSpacing = layout.minimumInteritemSpacing
        
        let availableWidth = collectionView.bounds.width - (horizontalPadding * 2) - (interItemSpacing * (itemsPerRow - 1))
        let widthPerItem = availableWidth / itemsPerRow

        let aspectRatio: CGFloat = 1.0 
        let heightPerItem = widthPerItem * aspectRatio
        
        let size = CGSize(width: widthPerItem, height: heightPerItem)
        return size
    }
}

