import Foundation

enum SocialPlatformType: String, CaseIterable, Codable {
    case all = "전체"
    case blog = "네이버 블로그"
    case instagram = "인스타그램"
    case youtube = "유튜브"
    case tiktok = "틱톡"
    case etc = "기타"
    
    var imageName: String {
        switch self {
        case .all: return "all"
        case .blog: return "naver_blog"
        case .instagram: return "insta"
        case .youtube: return "youtube"
        case .tiktok: return "tiktok"
        case .etc: return "etc"
        }
    }
    
    var connectGuideTitle: String {
        return "\(self.rawValue) 연결 가이드"
    }
    
    var connectGuideMessages: [String] {
        switch self {
        case .blog:
            return [
                "네이버 블로그 내 공개 상태의 포스트를 1개 이상 보유한 전체 공개된 블로그여야 합니다.",
                "네이버에서 허용한 앱 권한 상태 시, 네이버 블로그를 다시 연결하셔야 합니다."
            ]
        case .instagram:
            return [
                "인스타그램 계정 내 공개 상태의 게시물을 1개 이상 보유한 전체 공개된 계정이어야 합니다.",
                "인스타그램에서 허용한 앱 권한 상태 시, 인스타그램 계정을 다시 연결하셔야 합니다."
            ]
        case .youtube:
            return [
                "유튜브 채널 내 공개 상태의 영상을 1개 이상 보유한 전체 공개된 채널이어야 합니다.",
                "유튜브에서 허용한 앱 권한 상태 시, 유튜브 채널을 다시 연결하셔야 합니다."
            ]
        case .tiktok:
            return [
                "틱톡 계정 내 공개 상태의 영상을 1개 이상 보유한 전체 공개된 계정이어야 합니다.",
                "틱톡에서 허용한 앱 권한 상태 시, 틱톡 계정을 다시 연결하셔야 합니다."
            ]
        case .etc:
            return [
                "기타 플랫폼 계정 내 공개 상태의 콘텐츠를 1개 이상 보유한 전체 공개된 계정이어야 합니다.",
                "해당 플랫폼에서 허용한 앱 권한 상태 시, 계정을 다시 연결하셔야 합니다."
            ]
        default:
            return []
        }
    }
    
    /// URL 입력 플레이스홀더
    var urlPlaceholder: String {
        return "url을 입력해 주세요"
    }
    
    /// 연결 버튼 텍스트
    var connectButtonText: String {
        return "연결하기"
    }
    
    /// API 플랫폼 키 (API 요청 시 사용)
    var apiPlatformKey: String {
        switch self {
        case .blog:
            return "naver"
        case .instagram:
            return "instagram"
        case .youtube:
            return "youtube"
        case .tiktok:
            return "tiktok"
        case .etc:
            return "etc"
        default:
            return ""
        }
    }
    
    static func from(displayName: String) -> SocialPlatformType? {
        switch displayName {
        case "전체": return .all
        case "네이버 블로그": return .blog
        case "인스타그램": return .instagram
        case "유튜브": return .youtube
        case "틱톡": return .tiktok
        case "기타": return .etc
        default: return nil
        }
    }
}
