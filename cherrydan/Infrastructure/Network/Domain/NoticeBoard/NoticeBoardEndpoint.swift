import Foundation

enum NoticeBoardEndpoint: APIEndpoint {
    case getNoticeBoard
    case getNoticeBoardDetail(id: Int)
    case getNoticeBoardBanner
    
    var path: String {
        switch self {
        case .getNoticeBoard:
            return "/noticeboard"
        case .getNoticeBoardDetail(let id):
            return "/noticeboard/\(id)"
        case .getNoticeBoardBanner:
            return "/noticeboard/banners"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNoticeBoard, .getNoticeBoardDetail, .getNoticeBoardBanner:
            return .get
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
