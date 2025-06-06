import Foundation

enum SocialPlatform: String, CaseIterable, Codable {
    case instagram = "instagram"
    case youtube = "youtube"
    case naverBlog = "naver_blog"
    
    var displayName: String {
        switch self {
        case .instagram: return "인스타그램"
        case .youtube: return "유튜브"
        case .naverBlog: return "네이버 블로그"
        }
    }
    
    var imageName: String {
        switch self {
        case .instagram: return "instagram"
        case .youtube: return "youtube"
        case .naverBlog: return "naver"
        }
        
    }
}

struct CampaignData: Codable, Equatable, Identifiable {
    let id = UUID() // TODO: 서버에서 전달받는 ID로 추후 변경 필요
    let image: String
    let remainingDays: Int
    let title: String
    let subtitle: String
    let applicantCount: Int
    let totalApplicants: Int
    let socialPlatform: SocialPlatform
    let reviewPlatform: String
    
    static let dummy: [CampaignData] = [
        CampaignData(
            image: "https://picsum.photos/200",
            remainingDays: 6,
            title: "[화보H] 맛있는 로스 필스 체험",
            subtitle: "로스 필스 2인분",
            applicantCount: 23,
            totalApplicants: 12,
            socialPlatform: .instagram,
            reviewPlatform: "강남맛집"
        ),
        CampaignData(
            image: "https://picsum.photos/300",
            remainingDays: 11,
            title: "[먹방] 마늘마늘 삼겹살",
            subtitle: "마늘 삼겹살 2인분",
            applicantCount: 135,
            totalApplicants: 8,
            socialPlatform: .instagram,
            reviewPlatform: "리뷰노트"
        ),
        CampaignData(
            image: "https://picsum.photos/250",
            remainingDays: 17,
            title: "[양평] 스트로베리 카페",
            subtitle: "딸기 음료 2잔",
            applicantCount: 100,
            totalApplicants: 3,
            socialPlatform: .youtube,
            reviewPlatform: "카페리뷰"
        ),
        CampaignData(
            image: "https://picsum.photos/280",
            remainingDays: 3,
            title: "[양평] 양평 용기충전 독채 펜션",
            subtitle: "펜션 1박 2일",
            applicantCount: 80,
            totalApplicants: 10,
            socialPlatform: .naverBlog,
            reviewPlatform: "여행후기"
        ),
        CampaignData(
            image: "https://picsum.photos/320",
            remainingDays: 15,
            title: "[서울] 한강 피크닉 체험",
            subtitle: "피크닉 세트",
            applicantCount: 67,
            totalApplicants: 5,
            socialPlatform: .youtube,
            reviewPlatform: "서울나들이"
        ),
        CampaignData(
            image: "https://picsum.photos/240",
            remainingDays: 2,
            title: "[부산] 해운대 맛집 투어",
            subtitle: "맛집 투어 코스",
            applicantCount: 156,
            totalApplicants: 12,
            socialPlatform: .naverBlog,
            reviewPlatform: "부산맛집"
        )
    ]
}
