import Foundation

enum HomeRoute: BaseRoute {
    case home
    case search
    case notification(tab: NotificationType)
    case campaignWeb(siteNameKr: String, campaignSiteUrl: String)
    case selectRegion(viewModel: HomeViewModel)
    case keywordSettings
    case keywordAlertDetail(keyword: KeywordNotification)
    
    var id: String {
        switch self {
        case .campaignWeb(let siteNameKr, _):
            "campaignWeb_\(siteNameKr)"
        case .keywordAlertDetail(let keyword):
            "keywordAlertDetail_\(keyword)"
        default:
            String(describing: self)
        }
    }
    
    var analyticsName: String {
        switch self {
        case .home :
            "home_screen"
        case .search:
            "search_screen"
        case .notification(_):
            "notification_screen"
        case .campaignWeb:
            "campaign_web_screen"
        case .selectRegion:
            "select_region_screen"
        case .keywordSettings:
            "keyword_settings_screen"
        case .keywordAlertDetail:
            "keyword_alert_detail_screen"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

