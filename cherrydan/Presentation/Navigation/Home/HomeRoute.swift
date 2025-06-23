import Foundation

enum HomeRoute: BaseRoute {
    case search
    case notification
    
    var id: String {
        String(describing: self)
    }
    
    var analyticsName: String {
        switch self {
        case .search:
            "search_screen"
        case .notification:
            "notification_screen"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

