import Foundation

enum CampaignPlatformType: String, CaseIterable, Codable {
    case chvu = "체험뷰"
    case revu = "레뷰"
    case mibl = "미블"
    case reviewnote = "리뷰노트"
    case dailyview = "데일리뷰"
    case fourblog = "포블로그"
    case popomon = "포포몬"
    case dinnerqueen = "디너의 여왕"
    case seoulouba = "서울오빠"
    case cometoplay = "놀러와 체험단"
    case gangnam = "강남맛집"
    case etc = "기타"
    
    static var allCasesWithAll: [String] {
        return ["전체"] + CampaignPlatformType.allCases.map { $0.rawValue }
    }
    
    var imageName: String {
        switch self {
        case .chvu: "revu" // 체험뷰도 revu 이미지 사용
        case .revu: "revu"
        case .mibl: "mibl"
        case .reviewnote: "reviewnote"
        case .dailyview: "dailyview"
        case .fourblog: "fourblog"
        case .popomon: "popomon"
        case .dinnerqueen: "dinnerqueen"
        case .seoulouba: "seoulouba"
        case .cometoplay: "cometoplay"
        case .gangnam: "gangnam"
        case .etc: "etc"
        }
    }
    
    static func from(displayName: String) -> CampaignPlatformType {
        switch displayName {
        case "체험뷰": return .chvu
        case "레뷰": return .revu
        case "미블": return .mibl
        case "리뷰노트": return .reviewnote
        case "데일리뷰": return .dailyview
        case "포블로그": return .fourblog
        case "포포몬": return .popomon
        case "디너의 여왕": return .dinnerqueen
        case "서울오빠": return .seoulouba
        case "놀러와 체험단": return .cometoplay
        case "강남맛집": return .gangnam
        case "기타": return .etc
        default: return .chvu
        }
    }
} 
