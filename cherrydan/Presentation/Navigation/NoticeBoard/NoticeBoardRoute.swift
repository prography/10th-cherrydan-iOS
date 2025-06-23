import Foundation

enum NoticeBoardRoute: BaseRoute {
    case noticeDetail(noticeId: String)
    
    var id: String {
        String(describing: self)
    }
    
    var analyticsName: String {
        switch self {
        case .noticeDetail:
            "notice_detail_screen"
        }
    }
    
    var disableSwipeBack: Bool {
        false
    }
}

