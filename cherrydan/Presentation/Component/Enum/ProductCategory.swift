import Foundation

enum ProductCategory: String, CaseIterable, Codable {
    case food = "food"
    case living = "living"
    case digital = "digital"
    case beautyFashion = "beauty_fashion"
    case pet = "pet"
    case kids = "kids"
    case book = "book"
    case restaurant = "restaurant"
    case travel = "travel"
    case service = "service"
    case etc = "etc"
    
    var id: Int {
        switch self {
        case .food: return 1
        case .living: return 2
        case .digital: return 3
        case .beautyFashion: return 4
        case .pet: return 5
        case .kids: return 6
        case .book: return 7
        case .restaurant: return 8
        case .travel: return 9
        case .service: return 10
        case .etc: return 99
        }
    }
    
    var displayName: String {
        switch self {
        case .food: return "🍎식품"
        case .living: return "🧺생활"
        case .digital: return "📱디지털"
        case .beautyFashion: return "🧥뷰티/패션"
        case .pet: return "🐶반려동물"
        case .kids: return "🧸유아동"
        case .book: return "📚도서"
        case .restaurant: return "🍴맛집"
        case .travel: return "✈️여행"
        case .service: return "🪐서비스"
        case .etc: return "기타"
        }
    }
    
    static var allCasesWithAll: [String] {
        return ["전체"] + ProductCategory.allCases.map { $0.displayName }
    }
    
    static func from(displayName: String) -> ProductCategory? {
        switch displayName {
        case "🍎식품": return .food
        case "🧺생활": return .living
        case "📱디지털": return .digital
        case "🧥뷰티/패션": return .beautyFashion
        case "🐶반려동물": return .pet
        case "🧸유아동": return .kids
        case "📚도서": return .book
        case "🍴맛집": return .restaurant
        case "✈️여행": return .travel
        case "🪐서비스": return .service
        case "기타": return .etc
        default: return nil
        }
    }
    
    static func from(id: Int) -> ProductCategory {
        switch id {
        case 1: return .food
        case 2: return .living
        case 3: return .digital
        case 4: return .beautyFashion
        case 5: return .pet
        case 6: return .kids
        case 7: return .book
        case 8: return .restaurant
        case 9: return .travel
        case 10: return .service
        case 99: return .etc
        default: return .etc
        }
    }
} 