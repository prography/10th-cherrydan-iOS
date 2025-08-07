enum KeywordEndpoint: APIEndpoint {
    case getUserKeywords
    case addUserKeyword(keyword: String)
    case deleteUserKeyword(keywordId: Int)
    case getKeywordAlerts
    case deleteKeywordAlerts(alertIds: [Int])
    case markKeywordAlertsAsRead(alertIds: [Int])
    case getPersonalizedCampaignsByKeyword(keyword: String)
    
    var path: String {
        switch self {
        case .getUserKeywords:
            "/user/me/keywords"
        case .addUserKeyword:
            "/user/me/keywords"
        case .deleteUserKeyword(let keywordId):
            "/user/me/keywords/\(keywordId)"
        case .getKeywordAlerts:
            "/keywords/alerts"
        case .deleteKeywordAlerts:
            "/keywords/alerts"
        case .markKeywordAlertsAsRead:
            "/keywords/alerts/read"
        case .getPersonalizedCampaignsByKeyword:
            "/keywords/campaigns/personalized/keyword"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserKeywords, .getKeywordAlerts, .getPersonalizedCampaignsByKeyword:
            .get
        case .addUserKeyword:
            .post
        case .deleteUserKeyword, .deleteKeywordAlerts:
            .delete
        case .markKeywordAlertsAsRead:
            .put
        }
    }
    
    var tokenType: TokenType { 
        .accessToken 
    }
}