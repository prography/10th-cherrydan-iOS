enum ActivityEndpoint: APIEndpoint {
    case getActivityNotification
    case deleteActivityNotifications
    case markActivityAlertsAsRead
    
    var path: String {
        switch self {
        case .getActivityNotification:
            "/activity/bookmark-alerts"
        case .deleteActivityNotifications:
            "/activity/bookmark-alerts"
        case .markActivityAlertsAsRead:
            "/activity/bookmark-alerts/read"
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
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
