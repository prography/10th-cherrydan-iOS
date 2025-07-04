import Foundation

enum CategoryType: String, CaseIterable, Codable {
    case interestedRegion = "interested_region"
    case product = "product"
    case pressCorps = "press_corps"
    case snsPlatform = "sns_platform"
    case experiencePlatform = "experience_platform"
    case regionalCustom = "regional_custom"
    
    var title: String {
        switch self {
        case .interestedRegion:
            "관심 지역"
        case .product:
            "제품"
        case .pressCorps:
            "기자단"
        case .snsPlatform:
            "SNS 플랫폼"
        case .experiencePlatform:
            "체험단 플랫폼"
        case .regionalCustom:
            "지역 맞춤"
        }
    }
    
}
