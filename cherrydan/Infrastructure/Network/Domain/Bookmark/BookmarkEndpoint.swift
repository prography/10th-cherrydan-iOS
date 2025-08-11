enum BookmarkEndpoint: APIEndpoint {
    case addBookmark(campaignId: Int)
    case cancelBookmark(campaignId: Int)
    case deleteBookmark(campaignId: Int)
    case getOpenBookmarks
    case getClosedBookmarks
    
    var path: String {
        switch self {
        case .addBookmark(let campaignId):
            "/campaigns/\(campaignId)/bookmark"
        case .cancelBookmark(let campaignId):
            "/campaigns/\(campaignId)/bookmark"
        case .deleteBookmark(let campaignId):
            "/campaigns/\(campaignId)/bookmark"
        case .getOpenBookmarks:
            "/campaigns/bookmarks/open"
        case .getClosedBookmarks:
            "/campaigns/bookmarks/closed"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .addBookmark:
            .post
        case .cancelBookmark:
            .patch
        case .deleteBookmark:
            .delete
        case .getOpenBookmarks, .getClosedBookmarks:
            .get
        }
    }
    
    var tokenType: TokenType {
        .accessToken
    }
}
