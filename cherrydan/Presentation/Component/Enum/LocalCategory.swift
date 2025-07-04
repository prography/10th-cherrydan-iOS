import Foundation

enum LocalCategory: String, CaseIterable, Codable {
    case all = "all"
    case restaurant = "restaurant"
    case beauty = "beauty"
    case accommodation = "accommodation"
    case culture = "culture"
    case delivery = "delivery"
    case packaging = "packaging"
    case etc = "etc"
    
    var displayName: String {
        switch self {
        case .all: return "전체"
        case .restaurant: return "맛집"
        case .beauty: return "뷰티"
        case .accommodation: return "숙박"
        case .culture: return "문화"
        case .delivery: return "배달"
        case .packaging: return "포장"
        case .etc: return "기타"
        }
    }
    
    static func from(displayName: String) -> LocalCategory {
        switch displayName {
        case "전체": return .all
        case "맛집": return .restaurant
        case "뷰티": return .beauty
        case "숙박": return .accommodation
        case "문화": return .culture
        case "배달": return .delivery
        case "포장": return .packaging
        case "기타": return .etc
        default: return .all
        }
    }
} 