import Foundation

enum CampaignType: String, CaseIterable, Codable {
    case all = "ALL"
    case product = "PRODUCT"
    case region = "REGION"
    case reporter = "REPORTER"
    case etc = "ETC"
}
