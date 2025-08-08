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
} 
