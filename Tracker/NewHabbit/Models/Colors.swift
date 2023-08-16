import UIKit


struct Colors {
    
    let color: UIColor
    
    var image: UIImage {
        let size = CGSize(width: 46, height: 46)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image(actions: { context in
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fill(CGRect(origin: .zero, size: size))
        })
        return image
    }
    
    static let colors: [Colors] = [
            Colors(color: UIColor(red: 0.992, green: 0.298, blue: 0.286, alpha: 1)),
            Colors(color: UIColor(red: 0.976, green: 0.831, blue: 0.831, alpha: 1)),
            Colors(color: UIColor(red: 0.965, green: 0.769, blue: 0.545, alpha: 1)),
            Colors(color: UIColor(red: 1, green: 0.533, blue: 0.118, alpha: 1)),
            Colors(color: UIColor(red: 0.204, green: 0.655, blue: 0.996, alpha: 1)),
            Colors(color: UIColor(red: 0.475, green: 0.58, blue: 0.961, alpha: 1)),
            Colors(color: UIColor(red: 0, green: 0.482, blue: 0.98, alpha: 1)),
            Colors(color: UIColor(red: 0.275, green: 0.902, blue: 0.616, alpha: 1)),
            Colors(color: UIColor(red: 0.514, green: 0.173, blue: 0.945, alpha: 1)),
            Colors(color: UIColor(red: 0.431, green: 0.267, blue: 0.996, alpha: 1)),
            Colors(color: UIColor(red: 0.208, green: 0.204, blue: 0.486, alpha: 1)),
            Colors(color: UIColor(red: 0.678, green: 0.337, blue: 0.855, alpha: 1)),
            Colors(color: UIColor(red: 0.2, green: 0.812, blue: 0.412, alpha: 1)),
            Colors(color: UIColor(red: 1, green: 0.404, blue: 0.302, alpha: 1)),
            Colors(color: UIColor(red: 0.553, green: 0.447, blue: 0.902, alpha: 1)),
            Colors(color: UIColor(red: 0.902, green: 0.427, blue: 0.831, alpha: 1)),
            Colors(color: UIColor(red: 1, green: 0.6, blue: 0.8, alpha: 1)),
            Colors(color: UIColor(red: 0.184, green: 0.816, blue: 0.345, alpha: 1))
    ]
    
    static var count: Int {
        return colors.count
    }

    static func findColorIndex(color: UIColor) -> Int? {
        for (index, storedColor) in colors.enumerated() {
            let tolerance: CGFloat = 0.01
            if areColorsEqual(color1: color, color2: storedColor.color, tolerance: tolerance) {
                return index
            }
        }
        return nil
    }

    static func areColorsEqual(color1: UIColor, color2: UIColor, tolerance: CGFloat) -> Bool {
        var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0, a1: CGFloat = 0
        var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0, a2: CGFloat = 0
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        let deltaR = abs(r1 - r2)
        let deltaG = abs(g1 - g2)
        let deltaB = abs(b1 - b2)
        let deltaA = abs(a1 - a2)
        
        return deltaR <= tolerance && deltaG <= tolerance && deltaB <= tolerance && deltaA <= tolerance
    }

}
