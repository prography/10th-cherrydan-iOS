enum CampaignEndpoint: APIEndpoint {
    case getCampaignByType
    case getCampaignBySNSPlatform
    case getCampaignByCampaignPlatform
    case getCampainByCategory
    case searchCampaign
    
    var path: String {
        switch self {
        case .getCampaignByType:
            "/campaigns/types"
        case .getCampaignBySNSPlatform:
            "/campaigns/sns-platforms"
        case .getCampaignByCampaignPlatform:
            "/campaigns/campaign-platforms"
        case .searchCampaign:
            "/campaigns/search"
        case .getCampainByCategory:
            "/campaigns/categories/search"
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
        case .getCampainByCategory:
                .get
        case .searchCampaign:
                .get
        }
    }
    
    var tokenType: TokenType {
        .accessToken
    }
}

