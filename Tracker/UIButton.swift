import UIKit


extension UIButton {
    static func plusButtonInCircle(color: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 34
        
        let circleSize: CGFloat = 68
        let circleX = (button.bounds.width - circleSize) / 2
        let circleY = (button.bounds.height - circleSize) / 2
        let circleRect = CGRect(x: circleX, y: circleY, width: circleSize, height: circleSize)
        
        let circlePath = UIBezierPath(ovalIn: circleRect)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = color.cgColor
        
        let plusSize: CGFloat = 30
        let plusX = (circleSize - plusSize) / 2
        let plusY = (circleSize - plusSize) / 2
        let plusRect = CGRect(x: plusX, y: plusY, width: plusSize, height: plusSize)
        
        let plusPath = UIBezierPath()
        plusPath.move(to: CGPoint(x: plusRect.minX, y: plusRect.midY))
        plusPath.addLine(to: CGPoint(x: plusRect.maxX, y: plusRect.midY))
        plusPath.move(to: CGPoint(x: plusRect.midX, y: plusRect.minY))
        plusPath.addLine(to: CGPoint(x: plusRect.midX, y: plusRect.maxY))
        let plusLayer = CAShapeLayer()
        plusLayer.path = plusPath.cgPath
        plusLayer.strokeColor = UIColor.white.cgColor
        plusLayer.lineWidth = 2
        
        button.layer.addSublayer(circleLayer)
        button.layer.addSublayer(plusLayer)
        
        button.frame = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
        
        return button
    }
}




