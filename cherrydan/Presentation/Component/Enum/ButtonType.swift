import SwiftUI

enum ButtonType {
    case smallPrimary
    case smallWhite
    case smallGray
    
    case middlePrimary
    
    case largePrimary
    
    
    var font: Font {
        switch self {
        case .smallPrimary, .smallGray, .smallWhite:
                .m5r
        default:
                .m3r
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .smallWhite:
                .gray0
        case .smallGray:
                .gray2
        case .smallPrimary, .middlePrimary, .largePrimary:
                .mPink3
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .smallWhite:
                .gray5
        case .smallGray:
                .gray5
        case .smallPrimary, .middlePrimary, .largePrimary:
                .gray0
        }
    }
    
    var height: CGFloat {
        switch self {
        case .smallPrimary, .smallGray, .smallWhite:
            36
        default:
            56
        }
    }
    
    var disabledBackgroundColor: Color { .gray0 }
    var disabledForegroundColor: Color { .gray5 }
    var disabledStrokeColor: Color { .gray3 }
}
