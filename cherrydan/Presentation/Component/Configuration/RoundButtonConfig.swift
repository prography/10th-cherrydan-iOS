import SwiftUI

enum RoundButtonType {
    case gray
    case primary
    case white
    
    var font: Font {
        return .m5r
    }
    
    var backgroundColor: Color {
        switch self {
        case .gray:
            return .gray2
        case .primary:
            return .mPink2
        case .white:
            return .gray0
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .gray:
            return .gray5
        case .primary:
            return .white
        case .white:
            return .gray5
        }
    }
    
    var cornerRadius: CGFloat {
        return 16
    }
    
    var horizontalPadding: CGFloat {
        return 12
    }
    
    var verticalPadding: (top: CGFloat, bottom: CGFloat) {
        return (top: 6, bottom: 8)
    }
}

struct RoundButtonConfig {
    let text: String
    let type: RoundButtonType
    let onClick: () -> Void
    let disabled: Bool
    
    init(
        text: String,
        type: RoundButtonType = .gray,
        disabled: Bool = false,
        onClick: @escaping () -> Void
    ) {
        self.text = text
        self.type = type
        self.disabled = disabled
        self.onClick = onClick
    }
} 