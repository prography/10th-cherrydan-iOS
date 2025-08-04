import Foundation

enum LocalCategory: String, CaseIterable, Codable {
    case restaurant
    case beauty
    case accommodation
    case culture
    case delivery
    case takeout
    case etc
    
    var id: Int {
        switch self {
        case .restaurant: return 1
        case .beauty: return 2
        case .accommodation: return 3
        case .culture: return 4
        case .delivery: return 5
        case .takeout: return 6
        case .etc: return 99
        }
    }
    
    var displayName: String {
        switch self {
        case .restaurant: return "🍴맛집"
        case .beauty: return "💄뷰티"
        case .accommodation: return "⛺️숙박"
        case .culture: return "🕹문화"
        case .delivery: return "🛵배달"
        case .takeout: return "🥡포장"
        case .etc: return "기타"
        }
    }
    
    static func from(displayName: String) -> LocalCategory? {
        switch displayName {
        case "🍴맛집": return .restaurant
        case "💄뷰티": return .beauty
        case "⛺️숙박": return .accommodation
        case "🕹문화": return .culture
        case "🛵배달": return .delivery
        case "🥡포장": return .takeout
        case "기타": return .etc
        default: return nil
        }
    }
    
    static func from(id: Int) -> LocalCategory {
        switch id {
        case 1: return .restaurant
        case 2: return .beauty
        case 3: return .accommodation
        case 4: return .culture
        case 5: return .delivery
        case 6: return .takeout
        case 99: return .etc
        default: return .restaurant
        }
    }
} 
