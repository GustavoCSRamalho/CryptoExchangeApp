import UIKit

enum DesignSystem {
    enum Colors {
        static let primary = UIColor(hex: "#1E40AF")
        static let secondary = UIColor(hex: "#3B82F6")
        static let background = UIColor(hex: "#FFFFFF")
        static let secondaryBackground = UIColor(hex: "#F3F4F6")
        static let textPrimary = UIColor(hex: "#111827")
        static let textSecondary = UIColor(hex: "#6B7280")
        static let success = UIColor(hex: "#10B981")
        static let error = UIColor(hex: "#EF4444")
        static let cardBackground = UIColor(hex: "#FFFFFF")
        static let separator = UIColor(hex: "#E5E7EB")
    }
    
    enum Typography {
        static let titleLarge = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let titleSection = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let subtitle = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let caption = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let small = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
    
    enum Spacing {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
}

extension UIColor {
    
    /// Inicializador de cor com cÃ³digo hexadecimal
    /// - Parameter hex: String no formato "#RRGGBB" ou "RRGGBB"
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// Inicializador de cor com cÃ³digo hexadecimal e alpha
    /// - Parameters:
    ///   - hex: String no formato "#RRGGBB" ou "RRGGBB"
    ///   - alpha: Valor de transparÃªncia (0.0 a 1.0)
    convenience init(hex: String, alpha: CGFloat) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Converte UIColor para cÃ³digo hexadecimal
    /// - Returns: String no formato "#RRGGBB"
    func toHex() -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        
        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(red * 255),
            lroundf(green * 255),
            lroundf(blue * 255)
        )
    }
    
    /// Retorna uma versÃ£o mais clara da cor
    /// - Parameter percentage: Percentual de clareamento (0.0 a 1.0)
    /// - Returns: UIColor mais clara
    func lighter(by percentage: CGFloat = 0.2) -> UIColor {
        return adjust(by: abs(percentage))
    }
    
    /// Retorna uma versÃ£o mais escura da cor
    /// - Parameter percentage: Percentual de escurecimento (0.0 a 1.0)
    /// - Returns: UIColor mais escura
    func darker(by percentage: CGFloat = 0.2) -> UIColor {
        return adjust(by: -abs(percentage))
    }
    
    /// Ajusta o brilho da cor
    /// - Parameter percentage: Percentual de ajuste (positivo = mais claro, negativo = mais escuro)
    /// - Returns: UIColor ajustada
    private func adjust(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(
            red: min(red + percentage, 1.0),
            green: min(green + percentage, 1.0),
            blue: min(blue + percentage, 1.0),
            alpha: alpha
        )
    }
}
