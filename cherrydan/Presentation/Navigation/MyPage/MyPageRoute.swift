enum MyPageRoute: BaseRoute {
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
            "privacy_policy_screen\(type.rawValue)"
        }
    }
    
    var disableSwipeBack: Bool {
        switch self {
        case .profileSetting: true
        default: false
        }
    }
}

