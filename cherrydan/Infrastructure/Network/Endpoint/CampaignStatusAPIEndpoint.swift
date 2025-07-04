import Foundation

enum CampaignStatusAPIEndpoint {
    case myStatus
    case myStatusCreateOrUpdate
    case myStatusDelete
    case myStatusPatch
    case myStatusPopup
    
    var path: String {
        switch self {
        case .myStatus: return "/api/campaigns/my-status"
        case .myStatusCreateOrUpdate: return "/api/campaigns/my-status"
        case .myStatusDelete: return "/api/campaigns/my-status"
        case .myStatusPatch: return "/api/campaigns/my-status"
        case .myStatusPopup: return "/api/campaigns/my-status/popup"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .myStatus: return .get
        case .myStatusCreateOrUpdate: return .post
        case .myStatusDelete: return .delete
        case .myStatusPatch: return .patch
        case .myStatusPopup: return .get
        }
    }
} 