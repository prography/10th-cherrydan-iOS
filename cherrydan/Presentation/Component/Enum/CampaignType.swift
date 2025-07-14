import Foundation

enum CampaignType: String, CaseIterable, Codable {
    case all = "ALL"
    case region = "REGION"
    case product = "PRODUCT"
//    case reporter = "REPORTER"
    case snsPlatform = "SNS_PLATFORM"
    case campaignPlatform = "CAMPAIGN_PLATFORM"
    
    var title: String {
        switch self {
        case .all:
            "전체"
        case .region:
            "지역(방문형)"
        case .product:
            "제품(배송형)"
//        case .reporter:
//            "기자단"
        case .snsPlatform:
            "SNS 플랫폼"
        case .campaignPlatform:
            "체험단 플랫폼"
        }
    }
}
