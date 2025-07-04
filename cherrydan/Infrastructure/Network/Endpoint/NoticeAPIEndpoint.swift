import Foundation

enum NoticeAPIEndpoint {
    case noticeEmpathy(id: String)
    case notices
    case noticeDetail(id: String)
    case noticeBanners
    
    var path: String {
        switch self {
        case .noticeEmpathy(let id): return "/api/notices/\(id)/empathy"
        case .notices: return "/api/notices"
        case .noticeDetail(let id): return "/api/notices/\(id)"
        case .noticeBanners: return "/api/notices/banners"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .noticeEmpathy: return .post
        case .notices: return .get
        case .noticeDetail: return .get
        case .noticeBanners: return .get
        }
    }
} 