import Foundation

enum ProductCategory: String, CaseIterable, Codable {
    case all = "all"
    case food = "food"
    case beauty = "beauty"
    case fashion = "fashion"
    case lifestyle = "lifestyle"
    case health = "health"
    case tech = "tech"
    case pet = "pet"
    case baby = "baby"
    case etc = "etc"
    
    var displayName: String {
        switch self {
        case .all: return "전체"
        case .food: return "식품"
        case .beauty: return "뷰티"
        case .fashion: return "패션"
        case .lifestyle: return "라이프스타일"
        case .health: return "건강"
        case .tech: return "테크"
        case .pet: return "펫"
        case .baby: return "베이비"
        case .etc: return "기타"
        }
    }
} 