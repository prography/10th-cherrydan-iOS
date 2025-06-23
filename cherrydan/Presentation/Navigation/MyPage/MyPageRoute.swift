enum MyPageRoute: BaseRoute {
    case agreement
    case mediaConnect
    case profileSetting
    
    
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
        }
    }
    
    var disableSwipeBack: Bool {
        switch self {
        case .profileSetting: true
        default: false
        }
    }
}

