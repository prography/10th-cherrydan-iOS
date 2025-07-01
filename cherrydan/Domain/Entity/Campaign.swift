import Foundation

struct Campaign: Identifiable, Equatable, Codable {
    let id: Int
    let title: String
    let detailUrl: String
    let benefit: String
    let reviewerAnnouncementStatus: String
    let applicantCount: Int
    let recruitCount: Int
    let sourceSite: String
    let imageUrl: String
    let campaignType: CampaignType
    let address: String
    let competitionRate: Double
    let localCategory: Int
    let productCategory: Int
    let platforms: [String]
    
    // Computed properties for backward compatibility
    var image: String { imageUrl }
    var description: String { benefit }
    var totalApplicants: Int { recruitCount }
    var socialPlatform: SocialPlatform {
        if platforms.contains("instagram") { return .instagram }
        if platforms.contains("youtube") { return .youtube }
        if platforms.contains("naver_blog") { return .naverBlog }
        return .instagram // default
    }
    var reviewPlatform: String { benefit }
    
    static let dummy: [Campaign] = [
        Campaign(
            id: 1,
            title: "[중앙선술] 부산대 최고 규모 선술집",
            detailUrl: "https://example.com/campaign1",
            benefit: "50,000원 식사권(대표메뉴 1개 필수 주문)",
            reviewerAnnouncementStatus: "ANNOUNCED",
            applicantCount: 23,
            recruitCount: 12,
            sourceSite: "revu",
            imageUrl: "https://picsum.photos/200",
            campaignType: .region,
            address: "부산광역시",
            competitionRate: 1.92,
            localCategory: 1,
            productCategory: 1,
            platforms: ["instagram"]
        ),
        Campaign(
            id: 2,
            title: "[와모아] 일주일에 10kg 감량 가능! 살이 쭉쭉 빠져요! 맛있는 효소 릴스 체험",
            detailUrl: "https://example.com/campaign2",
            benefit: "효소 1박스",
            reviewerAnnouncementStatus: "ANNOUNCED",
            applicantCount: 135,
            recruitCount: 8,
            sourceSite: "revu",
            imageUrl: "https://picsum.photos/201",
            campaignType: .product,
            address: "서울특별시",
            competitionRate: 16.88,
            localCategory: 2,
            productCategory: 2,
            platforms: ["instagram", "youtube"]
        ),
        Campaign(
            id: 3,
            title: "[경기 가평군] 온델라카라반캠핑장 가평점",
            detailUrl: "https://example.com/campaign3",
            benefit: "(20만원 상당) 리버뷰 개인정원 카라반 숙박권 + 핀란드식 사우나 이용권",
            reviewerAnnouncementStatus: "ANNOUNCED",
            applicantCount: 100,
            recruitCount: 3,
            sourceSite: "revu",
            imageUrl: "https://picsum.photos/202",
            campaignType: .region,
            address: "경기도 가평군",
            competitionRate: 33.33,
            localCategory: 3,
            productCategory: 3,
            platforms: ["youtube", "naver_blog"]
        )
    ]
}

enum CampaignType: String, CaseIterable, Codable {
    case region = "REGION"
    case product = "PRODUCT"
    case service = "SERVICE"
    
    var displayName: String {
        switch self {
        case .region: return "지역"
        case .product: return "상품"
        case .service: return "서비스"
        }
    }
}

enum ReviewPlatform: String, CaseIterable, Codable {
    case revu = "revu"
    case youtube = "youtube"
    case naverBlog = "naver_blog"
    
    var displayName: String {
        switch self {
        case .revu: return "레뷰"
        case .youtube: return "유튜브"
        case .naverBlog: return "네이버 블로그"
        }
    }
    
    var imageName: String {
        String(describing: self)
    }
}

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
