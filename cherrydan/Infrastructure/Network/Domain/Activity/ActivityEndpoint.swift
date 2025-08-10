enum ActivityEndpoint: APIEndpoint {
    case getActivityNotification
    case deleteActivityNotifications
    case markActivityAlertsAsRead
    
    case getKeywordNotification
    
    var path: String {
        switch self {
        case .getActivityNotification:
            "/activity/notifications"
        case .deleteActivityNotifications:
            "/activity/alerts"
        case .markActivityAlertsAsRead:
            "/activity/notifications/read"
            
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
        case .markActivityAlertsAsRead:
                .patch
            
        case .getKeywordNotification:
                .get
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
