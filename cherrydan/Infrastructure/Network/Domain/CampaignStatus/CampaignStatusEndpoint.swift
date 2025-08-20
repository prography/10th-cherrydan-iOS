enum CampaignStatusEndpoint: APIEndpoint {
    case getAllMyStatus
    case createOrRecoverStatus
    case updateStatus
    case deleteStatus
    case getPopupStatus
    
    var path: String {
        switch self {
        case .getAllMyStatus:
            "/campaigns/my-status"
        case .createOrRecoverStatus:
            "/campaigns/my-status"
        case .updateStatus:
            "/campaigns/my-status"
        case .deleteStatus:
            "/campaigns/my-status"
        case .getPopupStatus:
            "/campaigns/my-status/popup"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllMyStatus:
            .get
        case .createOrRecoverStatus:
            .post
        case .updateStatus:
            .patch
        case .deleteStatus:
            .delete
        case .getPopupStatus:
            .get
        }
    }
    
    var tokenType: TokenType { .accessToken }
}