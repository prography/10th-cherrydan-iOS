import Foundation

enum KeywordCampaignAPIEndpoint {
    case keywordCampaignPersonalized
    case keywordAlerts
    case keywordAlertsDelete(alertId: String)
    
    var path: String {
        switch self {
        case .keywordCampaignPersonalized: return "/api/keywords/campaigns/personalized/keyword"
        case .keywordAlerts: return "/api/keywords/alerts"
        case .keywordAlertsDelete(let alertId): return "/api/keywords/alerts/\(alertId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .keywordCampaignPersonalized: return .get
        case .keywordAlerts: return .get
        case .keywordAlertsDelete: return .delete
        }
    }
} 