import UIKit

class ColorCell: UICollectionViewCell {
    
     static let identifier = "ColorCell"
    
    let colorView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
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
    
    func configure(colorCollectionView: UICollectionView, and data: [Colors]) {
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
    }
}

extension ColorCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
        let index = indexPath.row % Colors.count
        let color = Colors.colors[index]
        colorCell.colorView.backgroundColor = color.color
        return colorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader: id = "header"
        case UICollectionView.elementKindSectionFooter: id = "footer"
        default: id = ""
        }
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? ColorSupplementaryView else { return UICollectionReusableView() }
        view.titleLabel.text = "Цвет"
        return view
    }
}

extension ColorCell: UICollectionViewDelegate {
    
}

extension ColorCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPadding: CGFloat = 17
        let verticalPadding: CGFloat = 12
        let headerWidth = collectionView.bounds.width - (horizontalPadding * 2)
        let itemsPerRow: CGFloat = 6
        let rows: CGFloat = 3
        let availableWidth = headerWidth - horizontalPadding * (itemsPerRow - 1)
        let widthPerItem = availableWidth / itemsPerRow
        let availableHeight = collectionView.bounds.height - (verticalPadding * (rows - 1))
        let heightPerItem = availableHeight / rows
        let size = CGSize(width: widthPerItem, height: heightPerItem)
        return size
    }
}
