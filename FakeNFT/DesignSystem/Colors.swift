import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }
    
    // Ниже приведены примеры цветов, настоящие цвета надо взять из фигмы
    
    // Primary Colors
    static let primary = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0)
    
    // Secondary Colors
    static let secondary = UIColor(red: 255 / 255, green: 193 / 255, blue: 7 / 255, alpha: 1.0)
    
    // Background Colors
    static let background = UIColor.white
    static let backgroundEditProfileImage = UIColor(red: 26 / 255, green: 27 / 255, blue: 34 / 255, alpha: 0.6)
    
    static let greyUniversal = UIColor(red: 98/255, green: 92/255, blue: 92/255, alpha: 1.0)
    static let lightGray = UIColor(red: 247/255, green: 247/255, blue: 248/255, alpha: 1.0)

    // Object Colors
    static let blackLight = UIColor(hexString: "1A1B22")
    
    // Text Colors
    static let textPrimary = UIColor.black
    static let textSecondary = UIColor.gray
    static let textOnPrimary = UIColor.white
    static let textOnSecondary = UIColor.black
    static let yellowStar = UIColor(hexString: "#FEEF0D")
    static let heartRed = UIColor(hexString: "#F56B6C")
    static let siteBlue = UIColor(hexString: "#0A84FF")
    static let textGreen = UIColor(hexString: "#1C9F00")
    static let textRed = UIColor(hexString: "#F56B6C")
    
    // Dark Mode
    
    private static let yaBlackLight = UIColor(hexString: "1A1B22")
    private static let yaBlackDark = UIColor.white
    private static let yaLightGrayLight = UIColor(hexString: "#F7F7F8")
    private static let yaLightGrayDark = UIColor(hexString: "#2C2C2E")
    
    static let segmentActive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }
    
    static let backgroundColor = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackLight
        : .yaBlackDark
    }
    
    static let segmentInactive = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaLightGrayDark
        : .yaLightGrayLight
    }
    
    static let closeButton = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }
    
    static let darkObjectColor = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackDark
        : .yaBlackLight
    }
    
    static let whiteObjectColor = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaBlackLight
        : .yaBlackDark
    }
    
    static let paymentAreaColor = UIColor { traits in
        return traits.userInterfaceStyle == .dark
        ? .yaLightGrayDark
        : .yaLightGrayLight
    }
}
