import Foundation

enum HomeRoute: BaseRoute {
    case home
    case search
    case notification
    case campaignWeb(siteNameKr: String, campaignSiteUrl: String)
    case selectRegion(viewModel: HomeViewModel)
    
    var id: String {
        switch self {
        case .campaignWeb(let siteNameKr, _):
            "campaignWeb_\(siteNameKr)"
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
        case .notification:
            "notification_screen"
        case .campaignWeb:
            "campaign_web_screen"
        case .selectRegion:
            "select_region_screen"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

