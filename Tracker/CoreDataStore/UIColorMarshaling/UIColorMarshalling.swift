import UIKit

final class UIColorMarshalling {
    
    static func serializeColor(_ color: UIColor) -> String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)
        return String(format: "%02X%02X%02X", redInt, greenInt, blueInt)
    }
    
    static func deserialazeColor(_ hex: String) -> UIColor {
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat((rgbValue & 0x000FF)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
