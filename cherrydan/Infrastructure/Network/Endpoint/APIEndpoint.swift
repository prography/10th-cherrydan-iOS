import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum TokenType {
    case none
    case accessToken
    case refreshToken
}

enum APIEndpoint {
    case refresh
    case authLogout
    case socialLogin(String)
    case getActivityNotification
    case getKeywordNotification
    case deleteActivityNotifications(alerts: [String])
    
    case getCampaignByType
    case getCampaignBySNSPlatform
    case getCampaignByCampaignPlatform
    case getCampainByCategory
    
    case searchCampaign
    
    var tokenType: TokenType {
        switch self {
        case .socialLogin:
                .none
        default:
                .accessToken
        }
    }
    
    var path: String {
        switch self {
        case .refresh:
            "/auth/refresh"
        case .authLogout:
            "/auth/logout"
        case .socialLogin(let provider):
            "/auth/\(provider)/login"
            
        case .getActivityNotification:
            "/activity/notifications"
        case .getKeywordNotification:
            "/keywords/alerts"
        case .deleteActivityNotifications:
            "/activity/alerts"
        case .getCampaignByType:
            "/campaigns/types"
        case .getCampaignBySNSPlatform:
            "/campaigns/sns-platforms"
        case .getCampaignByCampaignPlatform:
            "/campaigns/campaign-platforms"
            
        case .searchCampaign:
            "/campaigns/search"
        case .getCampainByCategory:
            "/api/campaigns/categories/search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refresh:
                .post
        case .authLogout:
                .post
        case .socialLogin:
                .post
            
        case .getActivityNotification:
                .get
        case .getKeywordNotification:
                .get
        case .deleteActivityNotifications:
                .delete
        case .getCampaignByType:
                .get
        case .getCampaignBySNSPlatform:
                .get
        case .getCampaignByCampaignPlatform:
                .get
        case .getCampainByCategory:
                .get
        case .searchCampaign:
                .get
        }
    }
}
