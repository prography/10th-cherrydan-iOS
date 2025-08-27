enum CampaignStatusEndpoint: APIEndpoint {
    case getMyCampaigns
    case createOrRecoverStatus
    case updateStatus
    case deleteStatus
    case getPopupStatus
    case getCampaignStatusCount
    
    var path: String {
        switch self {
        case .getMyCampaigns:
            "/campaigns/my-status"
        case .createOrRecoverStatus:
            "/campaigns/my-status"
        case .updateStatus:
            "/campaigns/my-status"
        case .deleteStatus:
            "/campaigns/my-status"
        case .getPopupStatus:
            "/campaigns/my-status/popup"
        case .getCampaignStatusCount:
            "/campaigns/my-status/count"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMyCampaigns:
            .get
        case .createOrRecoverStatus:
            .post
        case .updateStatus:
            .patch
        case .deleteStatus:
            .delete
        case .getPopupStatus:
            .get
        case .getCampaignStatusCount:
            .get
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
