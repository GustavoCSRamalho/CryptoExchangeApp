import UIKit

enum AppColors {
    
    // MARK: - Primary Colors
    
    /// Cor primária principal - Azul Escuro Profissional (#1E3A8A)
    static let primary = UIColor(hex: "#1E3A8A")
    
    /// Cor primária clara - Azul Médio (#3B82F6)
    static let primaryLight = UIColor(hex: "#3B82F6")
    
    /// Cor primária escura - Azul Muito Escuro (#1E40AF)
    static let primaryDark = UIColor(hex: "#1E40AF")
    
    // MARK: - Secondary Colors
    
    /// Cor secundária - Verde para valores positivos (#10B981)
    static let secondary = UIColor(hex: "#10B981")
    
    /// Variante secundária - Vermelho para valores negativos (#EF4444)
    static let secondaryVariant = UIColor(hex: "#EF4444")
    
    // MARK: - Neutral Colors
    
    /// Cor de fundo principal - Cinza muito claro (#F9FAFB)
    static let background = UIColor(hex: "#F9FAFB")
    
    /// Cor de superfície - Branco (#FFFFFF)
    static let surface = UIColor(hex: "#FFFFFF")
    
    /// Variante de superfície - Cinza claro (#F3F4F6)
    static let surfaceVariant = UIColor(hex: "#F3F4F6")
    
    /// Cor de borda - Cinza médio claro (#E5E7EB)
    static let border = UIColor(hex: "#E5E7EB")
    
    // MARK: - Text Colors
    
    /// Texto primário - Preto quase (#111827)
    static let textPrimary = UIColor(hex: "#111827")
    
    /// Texto secundário - Cinza médio (#6B7280)
    static let textSecondary = UIColor(hex: "#6B7280")
    
    /// Texto terciário - Cinza claro (#9CA3AF)
    static let textTertiary = UIColor(hex: "#9CA3AF")
    
    /// Texto sobre primária - Branco (#FFFFFF)
    static let textOnPrimary = UIColor(hex: "#FFFFFF")
    
    // MARK: - Status Colors
    
    /// Sucesso - Verde (#10B981)
    static let success = UIColor(hex: "#10B981")
    
    /// Erro - Vermelho (#EF4444)
    static let error = UIColor(hex: "#EF4444")
    
    /// Aviso - Laranja (#F59E0B)
    static let warning = UIColor(hex: "#F59E0B")
    
    /// Informação - Azul (#3B82F6)
    static let info = UIColor(hex: "#3B82F6")
    
    // MARK: - Gradient Colors (Optional)
    
    /// Início do gradiente primário
    static let gradientStart = primaryDark
    
    /// Fim do gradiente primário
    static let gradientEnd = primaryLight
    
    // MARK: - Shadow Colors
    
    /// Sombra leve para cards
    static let shadowLight = UIColor.black.withAlphaComponent(0.1)
    
    /// Sombra média para elevação
    static let shadowMedium = UIColor.black.withAlphaComponent(0.2)
    
    /// Sombra escura para modais
    static let shadowDark = UIColor.black.withAlphaComponent(0.3)
    
    // MARK: - Special Colors
    
    /// Cor para valores positivos (alta/crescimento)
    static let positive = success
    
    /// Cor para valores negativos (queda/decrescimento)
    static let negative = error
    
    /// Cor para valores neutros
    static let neutral = textSecondary
    
    // MARK: - Overlay Colors
    
    /// Overlay escuro para modais/alerts
    static let overlayDark = UIColor.black.withAlphaComponent(0.5)
    
    /// Overlay claro para loading states
    static let overlayLight = UIColor.white.withAlphaComponent(0.8)
}

// MARK: - UIColor Extension (Hex Support)

extension UIColor {
    
    /// Inicializador de cor com código hexadecimal
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
    
    /// Inicializador de cor com código hexadecimal e alpha
    /// - Parameters:
    ///   - hex: String no formato "#RRGGBB" ou "RRGGBB"
    ///   - alpha: Valor de transparência (0.0 a 1.0)
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
    
    /// Converte UIColor para código hexadecimal
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
    
    /// Retorna uma versão mais clara da cor
    /// - Parameter percentage: Percentual de clareamento (0.0 a 1.0)
    /// - Returns: UIColor mais clara
    func lighter(by percentage: CGFloat = 0.2) -> UIColor {
        return adjust(by: abs(percentage))
    }
    
    /// Retorna uma versão mais escura da cor
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

// MARK: - Dark Mode Support (iOS 13+)

@available(iOS 13.0, *)
extension AppColors {
    
    /// Cor primária com suporte a Dark Mode
    static var primaryAdaptive: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? primaryLight : primary
        }
    }
    
    /// Cor de fundo com suporte a Dark Mode
    static var backgroundAdaptive: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#1F2937") : background
        }
    }
    
    /// Cor de superfície com suporte a Dark Mode
    static var surfaceAdaptive: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#374151") : surface
        }
    }
    
    /// Texto primário com suporte a Dark Mode
    static var textPrimaryAdaptive: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#F9FAFB") : textPrimary
        }
    }
    
    /// Texto secundário com suporte a Dark Mode
    static var textSecondaryAdaptive: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: "#D1D5DB") : textSecondary
        }
    }
}

// MARK: - Color Palette Documentation

/*
 
 PALETA DE CORES - CryptoExchangeApp
 ====================================
 
 PRIMARY COLORS:
 ---------------
 primary         #1E3A8A  rgb(30, 58, 138)   - Azul Escuro Profissional
 primaryLight    #3B82F6  rgb(59, 130, 246)  - Azul Médio
 primaryDark     #1E40AF  rgb(30, 64, 175)   - Azul Muito Escuro
 
 SECONDARY COLORS:
 -----------------
 secondary       #10B981  rgb(16, 185, 129)  - Verde (Valores Positivos)
 secondaryVariant #EF4444 rgb(239, 68, 68)   - Vermelho (Valores Negativos)
 
 NEUTRAL COLORS:
 ---------------
 background      #F9FAFB  rgb(249, 250, 251) - Cinza Muito Claro
 surface         #FFFFFF  rgb(255, 255, 255) - Branco
 surfaceVariant  #F3F4F6  rgb(243, 244, 246) - Cinza Claro
 border          #E5E7EB  rgb(229, 231, 235) - Cinza Médio Claro
 
 TEXT COLORS:
 ------------
 textPrimary     #111827  rgb(17, 24, 39)    - Preto Quase
 textSecondary   #6B7280  rgb(107, 114, 128) - Cinza Médio
 textTertiary    #9CA3AF  rgb(156, 163, 175) - Cinza Claro
 textOnPrimary   #FFFFFF  rgb(255, 255, 255) - Branco
 
 STATUS COLORS:
 --------------
 success         #10B981  rgb(16, 185, 129)  - Verde
 error           #EF4444  rgb(239, 68, 68)   - Vermelho
 warning         #F59E0B  rgb(245, 158, 11)  - Laranja
 info            #3B82F6  rgb(59, 130, 246)  - Azul
 
 USAGE EXAMPLES:
 ---------------
 
 // Cores básicas
 view.backgroundColor = AppColors.background
 label.textColor = AppColors.textPrimary
 button.backgroundColor = AppColors.primary
 
 // Status
 priceLabel.textColor = isPositive ? AppColors.positive : AppColors.negative
 
 // Hex
 let customColor = UIColor(hex: "#1E3A8A")
 
 // Manipulação
 let lighterBlue = AppColors.primary.lighter(by: 0.2)
 let darkerBlue = AppColors.primary.darker(by: 0.2)
 
 // Dark Mode (iOS 13+)
 view.backgroundColor = AppColors.backgroundAdaptive
 
 */
