import SwiftUI
import WebKit

enum MyPageWebType: String {
    case privacyPolicy
    case termsOfService
    case operationalPolicy
    case feedback
    
    var title: String {
        switch self {
        case .privacyPolicy:
            return "개인정보처리방침"
        case .termsOfService:
            return "이용약관"
        case .operationalPolicy:
            return "운영정책"
        case .feedback:
            return "피드백"
        }
    }
    
    var url: String {
        switch self {
        case .privacyPolicy:
            return "http://hataerin.notion.site/22c1517970678057bdf8ce7fd7b8e4aa?pvs=73"
        case .termsOfService:
            return "https://hataerin.notion.site/22c1517970678057a0c6cbcf77964204?pvs=73"
        case .operationalPolicy:
            return "https://hataerin.notion.site/22c15179706780d39b1ad23127d5b3ca?pvs=74"
        case .feedback:
            return "https://docs.google.com/forms/d/1TCtw3GJn3wqpoc-0OiFyleuI2L7O5sDmLO84EVGnyUc/preview"
        }
    }
}

struct WebDetailView: View {
    let myPageWebType: MyPageWebType
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: myPageWebType.title)
                .padding(.horizontal, 16)
            
            WebView(url: myPageWebType.url)
                .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
