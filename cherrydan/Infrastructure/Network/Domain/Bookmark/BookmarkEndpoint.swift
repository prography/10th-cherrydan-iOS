enum BookmarkEndpoint: APIEndpoint {
    case addBookmark(campaignId: Int)
    case cancelBookmark(campaignId: Int)
    case deleteBookmark(campaignId: Int)
    case getBookmarks
    
    var path: String {
        switch self {
        case .addBookmark(let campaignId):
            "/campaigns/\(campaignId)/bookmark"
        case .cancelBookmark(let campaignId):
            "/campaigns/\(campaignId)/bookmark"
        case .deleteBookmark(let campaignId):
            "/campaigns/\(campaignId)/bookmark"
        case .getBookmarks:
            "/campaigns/bookmarks"
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
        case .getBookmarks:
            .get
        }
    }
    
    var tokenType: TokenType {
        .accessToken
    }
}
