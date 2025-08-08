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
} 
