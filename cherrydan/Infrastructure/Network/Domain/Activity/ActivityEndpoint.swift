enum ActivityEndpoint: APIEndpoint {
    case getActivityNotification
    case deleteActivityNotifications(alerts: [String])
    
    case getKeywordNotification
    
    var path: String {
        switch self {
        case .getActivityNotification:
            "/activity/notifications"
        case .deleteActivityNotifications:
            "/activity/alerts"
            
        case .getKeywordNotification:
            "/keywords/alerts"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getActivityNotification:
                .get
        case .deleteActivityNotifications:
                .delete
            
        case .getKeywordNotification:
                .get
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
