import UIKit

enum AppFonts {
    
    // MARK: - Headings
    
    /// Heading 1 - 28pt, Bold
    /// Uso: Títulos principais, nomes de exchanges em detalhes
    static let heading1 = UIFont.systemFont(ofSize: 28, weight: .bold)
    
    /// Heading 2 - 24pt, Semibold
    /// Uso: Títulos de seções, cabeçalhos secundários
    static let heading2 = UIFont.systemFont(ofSize: 24, weight: .semibold)
    
    /// Heading 3 - 20pt, Semibold
    /// Uso: Subtítulos, nomes em cards
    static let heading3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
    
    // MARK: - Body
    
    /// Body Large - 16pt, Regular
    /// Uso: Texto principal, descrições, valores monetários
    static let bodyLarge = UIFont.systemFont(ofSize: 16, weight: .regular)
    
    /// Body Large Semibold - 16pt, Semibold
    /// Uso: Destaque em textos principais
    static let bodyLargeSemibold = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    /// Body Large Bold - 16pt, Bold
    /// Uso: Ênfase forte em textos principais
    static let bodyLargeBold = UIFont.systemFont(ofSize: 16, weight: .bold)
    
    /// Body Medium - 14pt, Regular
    /// Uso: Texto secundário, labels, informações
    static let bodyMedium = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    /// Body Medium Semibold - 14pt, Semibold
    /// Uso: Destaque em textos secundários
    static let bodyMediumSemibold = UIFont.systemFont(ofSize: 14, weight: .semibold)
    
    /// Body Small - 12pt, Regular
    /// Uso: Texto terciário, metadados, datas
    static let bodySmall = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    /// Body Small Semibold - 12pt, Semibold
    /// Uso: Destaque em textos pequenos
    static let bodySmallSemibold = UIFont.systemFont(ofSize: 12, weight: .semibold)
    
    // MARK: - Caption
    
    /// Caption - 11pt, Regular
    /// Uso: Legendas, notas de rodapé, IDs
    static let caption = UIFont.systemFont(ofSize: 11, weight: .regular)
    
    /// Caption Semibold - 11pt, Semibold
    /// Uso: Legendas com destaque
    static let captionSemibold = UIFont.systemFont(ofSize: 11, weight: .semibold)
    
    // MARK: - Button
    
    /// Button - 16pt, Semibold
    /// Uso: Texto de botões principais
    static let button = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    /// Button Small - 14pt, Semibold
    /// Uso: Texto de botões secundários
    static let buttonSmall = UIFont.systemFont(ofSize: 14, weight: .semibold)
    
    // MARK: - Navigation
    
    /// Navigation Title - 17pt, Semibold
    /// Uso: Título da navigation bar
    static let navigationTitle = UIFont.systemFont(ofSize: 17, weight: .semibold)
    
    /// Navigation Large Title - 34pt, Bold
    /// Uso: Large title da navigation bar
    static let navigationLargeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
    
    // MARK: - Special
    
    /// Price Large - 24pt, Bold
    /// Uso: Preços em destaque, valores principais
    static let priceLarge = UIFont.systemFont(ofSize: 24, weight: .bold)
    
    /// Price Medium - 18pt, Semibold
    /// Uso: Preços secundários
    static let priceMedium = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    /// Monospaced Number - 16pt, Regular (monospaced)
    /// Uso: Números, valores monetários (alinhamento)
    static let monospacedNumber: UIFont = {
        let font = UIFont.systemFont(ofSize: 16, weight: .regular)
        let monospacedFont = font.monospacedDigitFont
        return monospacedFont
    }()
    
    /// Monospaced Number Large - 24pt, Bold (monospaced)
    /// Uso: Preços grandes com alinhamento
    static let monospacedNumberLarge: UIFont = {
        let font = UIFont.systemFont(ofSize: 24, weight: .bold)
        let monospacedFont = font.monospacedDigitFont
        return monospacedFont
    }()
}

// MARK: - UIFont Extension

extension UIFont {
    
    /// Retorna uma versão monospaced da fonte (para alinhamento de números)
    var monospacedDigitFont: UIFont {
        let fontDescriptor = self.fontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: fontDescriptor, size: 0)
    }
    
    /// Retorna uma versão italic da fonte
    var italic: UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(.traitItalic)
        return UIFont(descriptor: descriptor ?? fontDescriptor, size: 0)
    }
    
    /// Retorna uma versão bold da fonte
    var bold: UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(.traitBold)
        return UIFont(descriptor: descriptor ?? fontDescriptor, size: 0)
    }
    
    /// Retorna fonte com weight específico
    /// - Parameter weight: Weight desejado
    /// - Returns: UIFont com o weight aplicado
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = fontDescriptor.addingAttributes([
            .traits: [UIFontDescriptor.TraitKey.weight: weight]
        ])
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    /// Retorna fonte com tamanho específico
    /// - Parameter size: Tamanho desejado
    /// - Returns: UIFont com o tamanho aplicado
    func withSize(_ size: CGFloat) -> UIFont {
        return UIFont(descriptor: fontDescriptor, size: size)
    }
}

// MARK: - UIFontDescriptor Extension

extension UIFontDescriptor {
    
    /// Retorna um descriptor com dígitos monospaced
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [
            [
                UIFontDescriptor.FeatureKey.type: kNumberSpacingType,
                UIFontDescriptor.FeatureKey.selector: kMonospacedNumbersSelector
            ]
        ]
        let fontDescriptorAttributes = [
            UIFontDescriptor.AttributeName.featureSettings: fontDescriptorFeatureSettings
        ]
        return addingAttributes(fontDescriptorAttributes)
    }
}

// MARK: - Dynamic Type Support

@available(iOS 11.0, *)
extension AppFonts {
    
    /// Heading 1 com suporte a Dynamic Type
    static var heading1Scaled: UIFont {
        return UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: heading1)
    }
    
    /// Heading 2 com suporte a Dynamic Type
    static var heading2Scaled: UIFont {
        return UIFontMetrics(forTextStyle: .title1).scaledFont(for: heading2)
    }
    
    /// Heading 3 com suporte a Dynamic Type
    static var heading3Scaled: UIFont {
        return UIFontMetrics(forTextStyle: .title2).scaledFont(for: heading3)
    }
    
    /// Body Large com suporte a Dynamic Type
    static var bodyLargeScaled: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: bodyLarge)
    }
    
    /// Body Medium com suporte a Dynamic Type
    static var bodyMediumScaled: UIFont {
        return UIFontMetrics(forTextStyle: .callout).scaledFont(for: bodyMedium)
    }
    
    /// Body Small com suporte a Dynamic Type
    static var bodySmallScaled: UIFont {
        return UIFontMetrics(forTextStyle: .footnote).scaledFont(for: bodySmall)
    }
    
    /// Caption com suporte a Dynamic Type
    static var captionScaled: UIFont {
        return UIFontMetrics(forTextStyle: .caption1).scaledFont(for: caption)
    }
}

// MARK: - Custom Fonts Support

extension AppFonts {
    
    /// Registra fontes customizadas do projeto
    /// Chamar no AppDelegate.didFinishLaunching
    static func registerCustomFonts() {
        // Exemplo de registro de fontes customizadas
        // registerFont(named: "CustomFont-Regular", withExtension: "ttf")
        // registerFont(named: "CustomFont-Bold", withExtension: "ttf")
    }
    
    /// Registra uma fonte customizada
    /// - Parameters:
    ///   - name: Nome do arquivo da fonte (sem extensão)
    ///   - extension: Extensão do arquivo (ttf, otf, etc)
    private static func registerFont(named name: String, withExtension extension: String) {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: `extension`),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("⚠️ Falha ao registrar fonte: \(name).\(`extension`)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("⚠️ Erro ao registrar fonte \(name): \(error.debugDescription)")
        } else {
            print("✅ Fonte registrada: \(name)")
        }
    }
    
    /// Cria uma fonte customizada
    /// - Parameters:
    ///   - name: Nome da fonte
    ///   - size: Tamanho da fonte
    /// - Returns: UIFont customizada ou fallback para system font
    static func customFont(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            print("⚠️ Fonte '\(name)' não encontrada, usando system font")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

// MARK: - Font Utilities

extension AppFonts {
    
    /// Lista todas as fontes disponíveis no sistema (útil para debug)
    static func listAllFonts() {
        #if DEBUG
        print("📝 Fontes Disponíveis:")
        for family in UIFont.familyNames.sorted() {
            print("\n📂 Família: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   • \(name)")
            }
        }
        #endif
    }
    
    /// Verifica se uma fonte está disponível
    /// - Parameter name: Nome da fonte
    /// - Returns: Bool indicando disponibilidade
    static func isFontAvailable(_ name: String) -> Bool {
        return UIFont.fontNames(forFamilyName: name).isEmpty == false ||
               UIFont(name: name, size: 12) != nil
    }
}

// MARK: - Typography Documentation

/*
 
 TIPOGRAFIA - CryptoExchangeApp
 ===============================
 
 HEADINGS:
 ---------
 heading1           28pt  Bold      - Títulos principais
 heading2           24pt  Semibold  - Títulos de seções
 heading3           20pt  Semibold  - Subtítulos
 
 BODY:
 -----
 bodyLarge          16pt  Regular   - Texto principal
 bodyLargeSemibold  16pt  Semibold  - Destaque principal
 bodyLargeBold      16pt  Bold      - Ênfase forte
 bodyMedium         14pt  Regular   - Texto secundário
 bodyMediumSemibold 14pt  Semibold  - Destaque secundário
 bodySmall          12pt  Regular   - Texto terciário
 bodySmallSemibold  12pt  Semibold  - Destaque terciário
 
 CAPTION:
 --------
 caption            11pt  Regular   - Legendas, IDs
 captionSemibold    11pt  Semibold  - Legendas com destaque
 
 BUTTON:
 -------
 button             16pt  Semibold  - Botões principais
 buttonSmall        14pt  Semibold  - Botões secundários
 
 NAVIGATION:
 -----------
 navigationTitle      17pt  Semibold  - Título navigation bar
 navigationLargeTitle 34pt  Bold      - Large title
 
 SPECIAL:
 --------
 priceLarge         24pt  Bold            - Preços em destaque
 priceMedium        18pt  Semibold        - Preços secundários
 monospacedNumber   16pt  Regular (mono)  - Números alinhados
 monospacedNumberLarge 24pt Bold (mono)   - Preços grandes alinhados
 
 USAGE EXAMPLES:
 ---------------
 
 // Uso básico
 titleLabel.font = AppFonts.heading1
 bodyLabel.font = AppFonts.bodyMedium
 priceLabel.font = AppFonts.priceLarge
 
 // Números alinhados
 priceLabel.font = AppFonts.monospacedNumber
 
 // Dynamic Type (acessibilidade)
 if #available(iOS 11.0, *) {
     titleLabel.font = AppFonts.heading1Scaled
     titleLabel.adjustsFontForContentSizeCategory = true
 }
 
 // Manipulação
 let boldFont = AppFonts.bodyMedium.bold
 let italicFont = AppFonts.bodyMedium.italic
 let customWeight = AppFonts.bodyMedium.withWeight(.semibold)
 let customSize = AppFonts.bodyMedium.withSize(18)
 
 // Custom fonts
 AppFonts.registerCustomFonts() // Chamar no AppDelegate
 let customFont = AppFonts.customFont(name: "CustomFont-Bold", size: 16)
 
 // Debug
 AppFonts.listAllFonts() // Lista todas as fontes disponíveis
 
 ACESSIBILIDADE:
 ---------------
 
 Para suportar Dynamic Type (ajuste de tamanho pelo usuário):
 
 1. Use as variantes *Scaled:
    label.font = AppFonts.bodyLargeScaled
 
 2. Habilite ajuste automático:
    label.adjustsFontForContentSizeCategory = true
 
 3. Teste com Settings → Accessibility → Display & Text Size → Larger Text
 
 */
