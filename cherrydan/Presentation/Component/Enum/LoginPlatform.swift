import SwiftUI

enum LoginPlatform {
    case naver
    case kakao
    case google
    case apple
    
    var rawName: String {
        String(describing: self)
    }
    
    
    var title: String {
        switch self{
        case .naver:
            "네이버"
        case .kakao:
            "카카오"
        case .google:
            "Google"
        case .apple:
            ""
        }
    }
    
    var backgroundColor: Color {
        switch self{
        case .naver:
                .naver
        case .kakao:
                .kakao
        case .google:
                .gray0
        case .apple:
                .gray0
        }
    }
}

