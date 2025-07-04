import Foundation

// API 응답용 DTO
struct CampaignDTO: Codable {
    let id: Int
    let title: String
    let detailUrl: String
    let benefit: String?
    let reviewerAnnouncementStatus: String?
    let applicantCount: Int
    let recruitCount: Int
    let imageUrl: String
    let campaignPlatformImageUrl: String?
    let campaignType: String  // 문자열로 받음
    let competitionRate: Double
    let campaignSite: String
    let snsPlatforms: [String]
}

// 실제 사용할 모델
struct Campaign: Identifiable, Equatable {
    let id: Int
    let title: String
    let detailUrl: String
    let benefit: String
    let reviewerAnnouncementStatus: String
    let applicantCount: Int
    let recruitCount: Int
    let imageUrl: String
    let campaignPlatformImageUrl: String
    let campaignType: CampaignType  // 열거형 사용
    let competitionRate: Double
    let campaignSite: CampaignPlatformType
    let snsPlatforms: [SocialPlatformType]
    
    // DTO에서 변환하는 이니셜라이저
    init(from response: CampaignDTO) {
        self.id = response.id
        self.title = response.title
        self.detailUrl = response.detailUrl
        self.benefit = response.benefit ?? "혜택 정보 없음"
        self.reviewerAnnouncementStatus = response.reviewerAnnouncementStatus ?? "발표 예정"
        self.applicantCount = response.applicantCount
        self.recruitCount = response.recruitCount
        self.imageUrl = response.imageUrl
        self.campaignPlatformImageUrl = response.campaignPlatformImageUrl ?? ""
        self.campaignType = CampaignType(rawValue: response.campaignType) ?? .product
        self.competitionRate = response.competitionRate
        self.campaignSite = CampaignPlatformType(rawValue: response.campaignSite) ?? .revu
        self.snsPlatforms = response.snsPlatforms.map { SocialPlatformType(rawValue: $0) ?? .instagram }
    }
    
    // 직접 생성용 이니셜라이저 (더미 데이터, 테스트 등)
    init(id: Int, title: String, detailUrl: String, benefit: String, reviewerAnnouncementStatus: String, applicantCount: Int, recruitCount: Int, imageUrl: String, campaignPlatformImageUrl: String, campaignType: CampaignType, competitionRate: Double, campaignSite: CampaignPlatformType, snsPlatforms: [SocialPlatformType]) {
        self.id = id
        self.title = title
        self.detailUrl = detailUrl
        self.benefit = benefit
        self.reviewerAnnouncementStatus = reviewerAnnouncementStatus
        self.applicantCount = applicantCount
        self.recruitCount = recruitCount
        self.imageUrl = imageUrl
        self.campaignPlatformImageUrl = campaignPlatformImageUrl
        self.campaignType = campaignType
        self.competitionRate = competitionRate
        self.campaignSite = campaignSite
        self.snsPlatforms = snsPlatforms
    }
    
    static let dummy: [Campaign] = [
        Campaign(
            id: 1,
            title: "[중앙선술] 부산대 최고 규모 선술집",
            detailUrl: "https://example.com/campaign1",
            benefit: "50,000원 식사권(대표메뉴 1개 필수 주문)",
            reviewerAnnouncementStatus: "ANNOUNCED",
            applicantCount: 23,
            recruitCount: 12,
            imageUrl: "https://picsum.photos/200",
            campaignPlatformImageUrl: "https://picsum.photos/50",
            campaignType: .region,
            competitionRate: 1.92,
            campaignSite: .revu,
            snsPlatforms: [.instagram]
        ),
        Campaign(
            id: 2,
            title: "[와모아] 일주일에 10kg 감량 가능! 살이 쭉쭉 빠져요! 맛있는 효소 릴스 체험",
            detailUrl: "https://example.com/campaign2",
            benefit: "효소 1박스",
            reviewerAnnouncementStatus: "ANNOUNCED",
            applicantCount: 135,
            recruitCount: 8,
            imageUrl: "https://picsum.photos/201",
            campaignPlatformImageUrl: "https://picsum.photos/51",
            campaignType: .product,
            competitionRate: 16.88,
            campaignSite: .revu,
            snsPlatforms: [.instagram,.youtube]
        ),
        Campaign(
            id: 3,
            title: "[경기 가평군] 온델라카라반캠핑장 가평점",
            detailUrl: "https://example.com/campaign3",
            benefit: "(20만원 상당) 리버뷰 개인정원 카라반 숙박권 + 핀란드식 사우나 이용권",
            reviewerAnnouncementStatus: "ANNOUNCED",
            applicantCount: 100,
            recruitCount: 3,
            imageUrl: "https://picsum.photos/202",
            campaignPlatformImageUrl: "https://picsum.photos/52",
            campaignType: .region,
            competitionRate: 33.33,
            campaignSite: .revu,
            snsPlatforms: [.youtube, .naverBlog]
        )
    ]
}

enum CampaignPlatformType: String, CaseIterable, Codable {
    case revu = "revu"
    case youtube = "youtube"
    case naverBlog = "naver_blog"
    case chvu = "체험뷰"
    
    var displayName: String {
        switch self {
        case .revu: return "레뷰"
        case .youtube: return "유튜브"
        case .naverBlog: return "네이버 블로그"
        case .chvu: return "체험뷰"
        }
    }
    
    var imageName: String {
        switch self {
        case .chvu: return "revu" // 체험뷰도 revu 이미지 사용
        default: return String(describing: self)
        }
    }
}

enum SocialPlatformType: String, CaseIterable, Codable {
    case all = "all"
    case naverBlog = "네이버 블로그"
    case instagram = "insta"
    case youtube = "youtube"
    case tiktok = "tiktok"
    case etc = "etc"
    
    var displayName: String {
        switch self {
        case .naverBlog: return "네이버 블로그"
        case .instagram: return "인스타그램"
        case .youtube: return "유튜브"
        case .tiktok: return "틱톡"
        case .etc: return "기타"
        default: return ""
        }
    }
    
    var imageName: String {
        switch self {
        case .naverBlog: return "naver"
        case .instagram: return "insta"
        case .youtube: return "youtube"
        case .tiktok: return "tiktok"
        case .etc: return "etc"
        default: return ""
        }
    }
}
