import Foundation

enum CategoryRoute: BaseRoute {
    case category
    case search
    case notification
    case categoryDetail(regionGroup: RegionGroup?, subRegion: SubRegion?)
    case campaignWeb(campaignSite: CampaignPlatformType, campaignSiteUrl: String)
    
    var id: String {
        switch self {
        case .categoryDetail(let regionGroup, let subRegion):
            "categoryDetail_\(regionGroup?.displayName ?? subRegion?.displayName ?? "error")"
        case .campaignWeb(let campaignSite, _):
            "campaignWeb_\(campaignSite.rawValue)"
        default:
            String(describing: self)
        }
    }
    
    var analyticsName: String {
        switch self {
        case .category:
            "category_main_screen"
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

