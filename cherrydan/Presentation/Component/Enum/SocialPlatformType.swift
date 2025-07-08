import Foundation

enum SocialPlatformType: String, CaseIterable, Codable {
    case blog = "네이버 블로그"
    case instagram = "인스타그램"
    case youtube = "유튜브"
    case tiktok = "틱톡"
    case etc = "기타"
    
    var imageName: String {
        switch self {
        case .blog: return "naver"
        case .instagram: return "insta"
        case .youtube: return "youtube"
        case .tiktok: return "tiktok"
        case .etc: return "etc"
        }
    }
    
    static var allCasesWithAll: [String] {
        return ["전체"] + SocialPlatformType.allCases.map { $0.rawValue }
    }
    
    static func from(displayName: String) -> SocialPlatformType? {
        switch displayName {
        case "블로그": return .blog
        case "인스타그램": return .instagram
        case "유튜브": return .youtube
        case "틱톡": return .tiktok
        default: return nil
        }
    }
} 


