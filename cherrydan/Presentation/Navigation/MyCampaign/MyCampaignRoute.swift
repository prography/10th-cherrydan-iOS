import Foundation

enum MyCampaignRoute: BaseRoute {
    case categoryDetail
    
    var id: String {
        String(describing: self)
    }
    
    var analyticsName: String {
        switch self {
        case .categoryDetail:
            "category_detail_screen"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

