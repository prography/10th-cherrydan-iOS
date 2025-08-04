import Foundation

enum NoticeBoardRoute: BaseRoute {
    case noticeBoard
    case noticeDetail(noticeId: String)
    case search
    case notification
    
    var id: String {
        String(describing: self)
    }
    
    var analyticsName: String {
        switch self {
        case .noticeBoard:
            "notice_board_screen"
        case .noticeDetail:
            "notice_detail_screen"
        case .search:
            "search_screen_noticeBoard"
        case .notification:
            "notification_screen_noticeBoard"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

