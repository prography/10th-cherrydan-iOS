import Foundation

enum CategoryRoute: BaseRoute {
    case search
    case notification
    case categoryDetail(region: String, isSub: Bool)
    
    var id: String {
        switch self {
        case .categoryDetail(let region, _):
            "categoryDetail_\(region)"
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
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

