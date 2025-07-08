import Foundation

enum NoticeBoardEndpoint: APIEndpoint {
    var tokenType: TokenType { .accessToken }
    
    case getNoticeBoard
    case getNoticeBoardDetail(id: Int)
    
    var path: String {
        switch self {
        case .getNoticeBoard:
            return "/notice-board"
        case .getNoticeBoardDetail(let id):
            return "/notice-board/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNoticeBoard, .getNoticeBoardDetail:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var body: Data? {
        return nil
    }
} 
