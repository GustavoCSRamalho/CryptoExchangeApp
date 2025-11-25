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
