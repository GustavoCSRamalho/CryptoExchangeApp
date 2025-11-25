import UIKit

enum AppSpacing {
    
    // MARK: - Base Spacing (8pt Grid System)
    
    /// Base unit para spacing (8pt)
    /// Todo spacing deve ser múltiplo deste valor
    private static let baseUnit: CGFloat = 8.0
    
    // MARK: - Standard Spacing
    
    /// Extra Small - 4pt
    /// Uso: Espaçamento mínimo entre elementos muito próximos
    static let extraSmall: CGFloat = baseUnit * 0.5  // 4pt
    
    /// Small - 8pt
    /// Uso: Espaçamento pequeno entre elementos relacionados
    static let small: CGFloat = baseUnit * 1  // 8pt
    
    /// Medium - 16pt
    /// Uso: Espaçamento padrão entre elementos, padding de cards
    static let medium: CGFloat = baseUnit * 2  // 16pt
    
    /// Large - 24pt
    /// Uso: Espaçamento entre seções, separação visual clara
    static let large: CGFloat = baseUnit * 3  // 24pt
    
    /// Extra Large - 32pt
    /// Uso: Espaçamento grande entre seções principais
    static let extraLarge: CGFloat = baseUnit * 4  // 32pt
    
    /// Huge - 40pt
    /// Uso: Espaçamento muito grande, margens especiais
    static let huge: CGFloat = baseUnit * 5  // 40pt
    
    // MARK: - Specific Spacing
    
    /// Spacing para stack views (12pt)
    static let stack: CGFloat = baseUnit * 1.5  // 12pt
    
    /// Spacing para stack views pequenos (6pt)
    static let stackSmall: CGFloat = baseUnit * 0.75  // 6pt
    
    /// Spacing para stack views grandes (20pt)
    static let stackLarge: CGFloat = baseUnit * 2.5  // 20pt
    
    // MARK: - Margins
    
    /// Margem horizontal padrão das telas
    static let horizontalMargin: CGFloat = medium  // 16pt
    
    /// Margem vertical padrão das telas
    static let verticalMargin: CGFloat = medium  // 16pt
    
    /// Margem horizontal pequena
    static let horizontalMarginSmall: CGFloat = small  // 8pt
    
    /// Margem horizontal grande
    static let horizontalMarginLarge: CGFloat = large  // 24pt
    
    // MARK: - Padding
    
    /// Padding interno de cards
    static let cardPadding: CGFloat = medium  // 16pt
    
    /// Padding interno de cards pequeno
    static let cardPaddingSmall: CGFloat = small  // 8pt
    
    /// Padding interno de cards grande
    static let cardPaddingLarge: CGFloat = large  // 24pt
    
    /// Padding de botões (horizontal)
    static let buttonPaddingHorizontal: CGFloat = large  // 24pt
    
    /// Padding de botões (vertical)
    static let buttonPaddingVertical: CGFloat = small  // 8pt
    
    /// Padding de células de tabela
    static let cellPadding: CGFloat = medium  // 16pt
    
    // MARK: - Corner Radius
    
    /// Corner radius pequeno
    static let cornerRadiusSmall: CGFloat = 4.0
    
    /// Corner radius médio (padrão para cards)
    static let cornerRadiusMedium: CGFloat = 8.0
    
    /// Corner radius grande
    static let cornerRadiusLarge: CGFloat = 12.0
    
    /// Corner radius extra grande
    static let cornerRadiusExtraLarge: CGFloat = 16.0
    
    /// Corner radius circular (para avatares, logos)
    static func cornerRadiusCircular(size: CGFloat) -> CGFloat {
        return size / 2
    }
    
    // MARK: - Icon Sizes
    
    /// Tamanho de ícone pequeno
    static let iconSmall: CGFloat = 16.0
    
    /// Tamanho de ícone médio
    static let iconMedium: CGFloat = 24.0
    
    /// Tamanho de ícone grande
    static let iconLarge: CGFloat = 32.0
    
    /// Tamanho de ícone extra grande
    static let iconExtraLarge: CGFloat = 48.0
    
    // MARK: - Logo Sizes
    
    /// Tamanho de logo pequeno (células)
    static let logoSmall: CGFloat = 48.0
    
    /// Tamanho de logo médio
    static let logoMedium: CGFloat = 80.0
    
    /// Tamanho de logo grande (detalhes)
    static let logoLarge: CGFloat = 120.0
    
    // MARK: - Heights
    
    /// Altura de botão padrão
    static let buttonHeight: CGFloat = 50.0
    
    /// Altura de botão pequeno
    static let buttonHeightSmall: CGFloat = 40.0
    
    /// Altura de botão grande
    static let buttonHeightLarge: CGFloat = 56.0
    
    /// Altura de célula padrão
    static let cellHeight: CGFloat = 80.0
    
    /// Altura de célula pequena
    static let cellHeightSmall: CGFloat = 60.0
    
    /// Altura de célula grande
    static let cellHeightLarge: CGFloat = 100.0
    
    /// Altura de search bar
    static let searchBarHeight: CGFloat = 44.0
    
    /// Altura de tab bar (padrão iOS)
    static let tabBarHeight: CGFloat = 49.0
    
    /// Altura de navigation bar (padrão iOS)
    static let navigationBarHeight: CGFloat = 44.0
    
    // MARK: - Shadow
    
    /// Offset de sombra leve
    static let shadowOffsetLight = CGSize(width: 0, height: 2)
    
    /// Offset de sombra média
    static let shadowOffsetMedium = CGSize(width: 0, height: 4)
    
    /// Offset de sombra pesada
    static let shadowOffsetHeavy = CGSize(width: 0, height: 8)
    
    /// Radius de sombra leve
    static let shadowRadiusLight: CGFloat = 4.0
    
    /// Radius de sombra média
    static let shadowRadiusMedium: CGFloat = 8.0
    
    /// Radius de sombra pesada
    static let shadowRadiusHeavy: CGFloat = 16.0
    
    /// Opacity de sombra leve
    static let shadowOpacityLight: Float = 0.1
    
    /// Opacity de sombra média
    static let shadowOpacityMedium: Float = 0.2
    
    /// Opacity de sombra pesada
    static let shadowOpacityHeavy: Float = 0.3
    
    // MARK: - Border
    
    /// Largura de borda fina
    static let borderWidthThin: CGFloat = 0.5
    
    /// Largura de borda padrão
    static let borderWidthRegular: CGFloat = 1.0
    
    /// Largura de borda grossa
    static let borderWidthThick: CGFloat = 2.0
    
    // MARK: - Animation Duration
    
    /// Duração de animação rápida
    static let animationDurationFast: TimeInterval = 0.2
    
    /// Duração de animação padrão
    static let animationDurationNormal: TimeInterval = 0.3
    
    /// Duração de animação lenta
    static let animationDurationSlow: TimeInterval = 0.5
    
    // MARK: - Screen Margins
    
    /// Safe area insets padrão (para cálculos)
    static let safeAreaTopDefault: CGFloat = 44.0
    static let safeAreaBottomDefault: CGFloat = 34.0
    
    // MARK: - Minimum Touch Target
    
    /// Tamanho mínimo de área tocável (Human Interface Guidelines)
    static let minimumTouchTarget: CGFloat = 44.0
}

// MARK: - UIEdgeInsets Extension

extension AppSpacing {
    
    /// Edge insets com spacing uniforme
    /// - Parameter spacing: Valor do spacing
    /// - Returns: UIEdgeInsets com valores iguais
    static func insets(_ spacing: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: spacing,
            left: spacing,
            bottom: spacing,
            right: spacing
        )
    }
    
    /// Edge insets com spacing horizontal e vertical
    /// - Parameters:
    ///   - horizontal: Spacing horizontal (left e right)
    ///   - vertical: Spacing vertical (top e bottom)
    /// - Returns: UIEdgeInsets configurado
    static func insets(horizontal: CGFloat, vertical: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal
        )
    }
    
    /// Edge insets padrão para cards
    static var cardInsets: UIEdgeInsets {
        return insets(cardPadding)
    }
    
    /// Edge insets padrão para células
    static var cellInsets: UIEdgeInsets {
        return insets(cellPadding)
    }
    
    /// Edge insets padrão para margens de tela
    static var screenInsets: UIEdgeInsets {
        return insets(horizontal: horizontalMargin, vertical: verticalMargin)
    }
    
    /// Edge insets para botões
    static var buttonInsets: UIEdgeInsets {
        return insets(horizontal: buttonPaddingHorizontal, vertical: buttonPaddingVertical)
    }
}

// MARK: - CGSize Extension

extension AppSpacing {
    
    /// Size quadrado com valor único
    /// - Parameter size: Largura e altura
    /// - Returns: CGSize quadrado
    static func size(_ size: CGFloat) -> CGSize {
        return CGSize(width: size, height: size)
    }
    
    /// Size para ícone pequeno
    static var iconSmallSize: CGSize {
        return size(iconSmall)
    }
    
    /// Size para ícone médio
    static var iconMediumSize: CGSize {
        return size(iconMedium)
    }
    
    /// Size para ícone grande
    static var iconLargeSize: CGSize {
        return size(iconLarge)
    }
    
    /// Size para logo pequeno
    static var logoSmallSize: CGSize {
        return size(logoSmall)
    }
    
    /// Size para logo médio
    static var logoMediumSize: CGSize {
        return size(logoMedium)
    }
    
    /// Size para logo grande
    static var logoLargeSize: CGSize {
        return size(logoLarge)
    }
}

// MARK: - UIView Extension (Layout Helpers)

extension UIView {
    
    /// Adiciona padding em todos os lados
    /// - Parameter padding: Valor do padding
    func addPadding(_ padding: CGFloat) {
        layoutMargins = AppSpacing.insets(padding)
    }
    
    /// Adiciona padding horizontal e vertical
    /// - Parameters:
    ///   - horizontal: Padding horizontal
    ///   - vertical: Padding vertical
    func addPadding(horizontal: CGFloat, vertical: CGFloat) {
        layoutMargins = AppSpacing.insets(horizontal: horizontal, vertical: vertical)
    }
    
    /// Adiciona sombra padrão
    /// - Parameter style: Estilo da sombra (light, medium, heavy)
    func addShadow(style: ShadowStyle = .medium) {
        layer.masksToBounds = false
        
        switch style {
        case .light:
            layer.shadowOffset = AppSpacing.shadowOffsetLight
            layer.shadowRadius = AppSpacing.shadowRadiusLight
            layer.shadowOpacity = AppSpacing.shadowOpacityLight
            
        case .medium:
            layer.shadowOffset = AppSpacing.shadowOffsetMedium
            layer.shadowRadius = AppSpacing.shadowRadiusMedium
            layer.shadowOpacity = AppSpacing.shadowOpacityMedium
            
        case .heavy:
            layer.shadowOffset = AppSpacing.shadowOffsetHeavy
            layer.shadowRadius = AppSpacing.shadowRadiusHeavy
            layer.shadowOpacity = AppSpacing.shadowOpacityHeavy
        }
        
        layer.shadowColor = UIColor.black.cgColor
    }
    
    /// Remove sombra
    func removeShadow() {
        layer.shadowOpacity = 0
    }
    
    /// Adiciona borda
    /// - Parameters:
    ///   - width: Largura da borda
    ///   - color: Cor da borda
    func addBorder(width: CGFloat = AppSpacing.borderWidthRegular, color: UIColor = AppColors.border) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    /// Remove borda
    func removeBorder() {
        layer.borderWidth = 0
    }
    
    /// Adiciona corner radius
    /// - Parameter radius: Valor do corner radius
    func addCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// Torna a view circular
    func makeCircular() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }
}

// MARK: - Shadow Style

enum ShadowStyle {
    case light
    case medium
    case heavy
}

// MARK: - Spacing Documentation

/*
 
 ESPAÇAMENTOS - CryptoExchangeApp
 =================================
 
 SISTEMA DE GRID: 8pt
 --------------------
 Todos os espaçamentos são múltiplos de 8pt para consistência visual
 
 SPACING PADRÃO:
 ---------------
 extraSmall    4pt   - Espaçamento mínimo
 small         8pt   - Elementos relacionados
 medium        16pt  - Padrão entre elementos
 large         24pt  - Entre seções
 extraLarge    32pt  - Seções principais
 huge          40pt  - Margens especiais
 
 MARGINS:
 --------
 horizontalMargin      16pt  - Margem horizontal padrão
 verticalMargin        16pt  - Margem vertical padrão
 horizontalMarginSmall 8pt   - Margem horizontal pequena
 horizontalMarginLarge 24pt  - Margem horizontal grande
 
 PADDING:
 --------
 cardPadding              16pt  - Padding interno de cards
 buttonPaddingHorizontal  24pt  - Padding horizontal de botões
 buttonPaddingVertical    8pt   - Padding vertical de botões
 cellPadding              16pt  - Padding de células
 
 CORNER RADIUS:
 --------------
 cornerRadiusSmall       4pt   - Pequeno
 cornerRadiusMedium      8pt   - Médio (cards)
 cornerRadiusLarge       12pt  - Grande
 cornerRadiusExtraLarge  16pt  - Extra grande
 
 SIZES:
 ------
 Ícones:  16pt, 24pt, 32pt, 48pt
 Logos:   48pt, 80pt, 120pt
 Botões:  40pt, 50pt, 56pt (altura)
 Células: 60pt, 80pt, 100pt (altura)
 
 SHADOW:
 -------
 Light:   offset(0,2)  radius:4   opacity:0.1
 Medium:  offset(0,4)  radius:8   opacity:0.2
 Heavy:   offset(0,8)  radius:16  opacity:0.3
 
 USAGE EXAMPLES:
 ---------------
 
 // Constraints com spacing
 label.topAnchor.constraint(
     equalTo: view.topAnchor,
     constant: AppSpacing.medium
 )
 
 stackView.spacing = AppSpacing.small
 
 // Edge Insets
 tableView.contentInset = AppSpacing.screenInsets
 button.contentEdgeInsets = AppSpacing.buttonInsets
 
 // Layout Margins
 view.layoutMargins = AppSpacing.insets(AppSpacing.medium)
 
 // View Helpers
 cardView.addCornerRadius(AppSpacing.cornerRadiusMedium)
 cardView.addShadow(style: .medium)
 cardView.addBorder()
 cardView.addPadding(AppSpacing.cardPadding)
 
 // Sizes
 imageView.widthAnchor.constraint(equalToConstant: AppSpacing.logoSmall)
 button.heightAnchor.constraint(equalToConstant: AppSpacing.buttonHeight)
 
 // Animações
 UIView.animate(withDuration: AppSpacing.animationDurationNormal) {
     view.alpha = 0
 }
 
 GRID SYSTEM (8pt):
 ------------------
 4pt   = 0.5 × 8pt
 8pt   = 1.0 × 8pt
 12pt  = 1.5 × 8pt
 16pt  = 2.0 × 8pt
 20pt  = 2.5 × 8pt
 24pt  = 3.0 × 8pt
 32pt  = 4.0 × 8pt
 40pt  = 5.0 × 8pt
 
 HUMAN INTERFACE GUIDELINES:
 ---------------------------
 - Área tocável mínima: 44pt × 44pt
 - Margens de leitura: 16pt
 - Espaçamento entre elementos: 8pt+
 - Corner radius para cards: 8-12pt
 
 */
