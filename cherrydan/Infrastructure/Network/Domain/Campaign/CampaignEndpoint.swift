enum CampaignEndpoint: APIEndpoint {
    case getCampaignByType
    case getCampaignBySNSPlatform
    case getCampaignByCampaignPlatform
    case getCampaign
    case getCampaignPlatform
    case getCampaignByCategory
    case getMyCampaignByStatus
    
    var path: String {
        switch self {
        case .getCampaignByType:
            "/campaigns/types"
        case .getCampaignBySNSPlatform:
            "/campaigns/sns-platforms"
        case .getCampaignByCampaignPlatform:
            "/campaigns/campaign-platforms"
            
        case .getCampaign:
            "/campaigns/search"
        case .getCampaignPlatform:
            "/campaigns/site"
        case .getCampaignByCategory:
            "/campaigns/categories/search"
        case .getMyCampaignByStatus:
            "/api/campaigns/my-status"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case    .getCampaignByType,
                .getCampaignBySNSPlatform,
                .getCampaignByCampaignPlatform,
                .getCampaignByCategory,
                .getCampaign,
                .getCampaignPlatform,
                .getMyCampaignByStatus:
                .get
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case    .getCampaignByCategory,
                .getCampaign:
                .none
        default:
                .accessToken
        }
    }
}

