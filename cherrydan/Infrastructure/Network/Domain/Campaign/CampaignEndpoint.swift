enum CampaignEndpoint: APIEndpoint {
    case getCampaignByType
    case getCampaignBySNSPlatform
    case getCampaignByCampaignPlatform
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
            
        case .getCampaignByCategory:
            "/campaigns/categories/search"
        case .getMyCampaignByStatus:
            "/api/campaigns/my-status"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCampaignByType:
                .get
        case .getCampaignBySNSPlatform:
                .get
        case .getCampaignByCampaignPlatform:
                .get
        case .getCampaignByCategory:
                .get
        case .getMyCampaignByStatus:
                .get
        }
    }
    
    var tokenType: TokenType {
        .accessToken
    }
}

