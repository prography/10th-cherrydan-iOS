enum MyPageRoute: BaseRoute {
    case myPage
    case agreement
    case mediaConnect
    case manageSNS
    case profileSetting
    case search
    case notification
    case withdrawal
    case myPageDetail(type: MyPageWebType)
    
    var id: String {
        String(describing: self)
    }
    
    var analyticsName: String {
        switch self {
        case .myPage:
            "my_page_screen"
        case .agreement:
            "agreement_screen"
        case .mediaConnect:
            "media_connect_screen"
            
        case .profileSetting:
            "profile_setting_screen"
            
        case .manageSNS:
            "manage_sns_screen"
        case .search:
            "search_screen_myPage"
        case .notification:
            "notification_screen_myPage"
        case .withdrawal:
            "withdrawal_screen"
            
        case .myPageDetail(let type):
            "my_page_web_screen_\(type.rawValue)"
        }
    }
    
    var disableSwipeBack: Bool {
        switch self {
        case .profileSetting: true
        default: false
        }
    }
}

// 안드로이드 앱 패키지 이름
// 마켓 URL
// 키 해시
