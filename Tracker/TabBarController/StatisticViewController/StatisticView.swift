import UIKit


final class StatisticView: UIView {
    
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 7
        stackView.layoutMargins = UIEdgeInsets(top: 12,
                                               left: 12,
                                               bottom: 12,
                                               right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var counterLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    init(description: String, counter: String) {
        super.init(frame: UIScreen.main.bounds)
        stackView.addArrangedSubview(counterLabel)
        stackView.addArrangedSubview(descriptionLabel)
        addSubview(stackView)
        descriptionLabel.text = description
        counterLabel.text = counter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCounter(newCounter: Int) {
        counterLabel.text = String(newCounter)
    }
    
    func configureBorder() {
        layer.masksToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: bounds.size)
        gradient.colors = [
            UIColor.red.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        let bezierPath = UIBezierPath(roundedRect: gradient.frame.insetBy(dx: 1.0, dy: 1.0), cornerRadius: 16)
        shape.path = bezierPath.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        gradient.mask = shape
        layer.addSublayer(gradient)
    }
}
