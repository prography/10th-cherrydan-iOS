import Foundation

enum CategoryRoute: BaseRoute {
    case search
    case notification
    case categoryDetail(region: String, isSub: Bool)
    case campaignWeb(campaignSite: CampaignPlatformType, campaignSiteUrl: String)
    
    var id: String {
        switch self {
        case .categoryDetail(let region, _):
            "categoryDetail_\(region)"
        case .campaignWeb(let campaignSite, _):
            "campaignWeb_\(campaignSite.rawValue)"
        default:
            String(describing: self)
        }
    }
    
    var analyticsName: String {
        switch self {
        case .categoryDetail:
            "category_detail_screen"
        case .search:
            "search_screen_category"
        case .notification:
            "notification_screen_category"
        case .campaignWeb:
            "campaign_web_screen"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

