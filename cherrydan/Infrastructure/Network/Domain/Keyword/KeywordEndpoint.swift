enum KeywordEndpoint: APIEndpoint {
    case markKeywordAlertsAsRead(alertIds: [Int])
    case getUserKeywords
    case addUserKeyword(keyword: String)
    case getPersonalizedCampaignsByKeyword(keyword: String)
    case getKeywordAlerts
    case deleteKeywordAlerts(alertIds: [Int])
    case deleteUserKeyword(keywordId: Int)
    
    var path: String {
        switch self {
        case .markKeywordAlertsAsRead:
            "/keywords/alerts/read"
        case .getUserKeywords:
            "/keywords/me"
        case .addUserKeyword:
            "/keywords/me"
        case .getPersonalizedCampaignsByKeyword:
            "/keywords/campaigns/personalized"
        case .getKeywordAlerts:
            "/keywords/alerts"
        case .deleteKeywordAlerts:
            "/keywords/alerts"
        case .deleteUserKeyword(let keywordId):
            "/keywords/me/\(keywordId)"
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
