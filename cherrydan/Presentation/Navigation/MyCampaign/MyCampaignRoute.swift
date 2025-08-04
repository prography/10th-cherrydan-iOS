import Foundation

enum MyCampaignRoute: BaseRoute {
    case category
    case categoryDetail
    
    var id: String {
        String(describing: self)
    }
    
    var analyticsName: String {
        switch self {
        case .category:
        "category_screen"
        case .categoryDetail:
            "category_detail_screen"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

