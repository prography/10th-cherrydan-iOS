import Foundation

struct MyCampaignDTO: Codable {
    let id: Int
    let campaignId: Int
    let userId: Int
    let reviewerAnnouncementStatus: String
    let statusLabel: String
    let title: String
    let benefit: String
    let detailUrl: String
    let imageUrl: String
    let campaignPlatformImageUrl: String
    let applicantCount: Int
    let recruitCount: Int
    let snsPlatforms: [String]
    let campaignSite: String
}

struct MyCampaign: Identifiable, Equatable {
    let id: Int
    let campaignId: Int
    let userId: Int
    let reviewerAnnouncementStatus: String
    let statusLabel: String
    let title: String
    let benefit: String
    let detailUrl: String
    let imageUrl: String
    let campaignPlatformImageUrl: String
    let applicantCount: Int
    let recruitCount: Int
    let snsPlatforms: [SocialPlatformType]
    let campaignSite: CampaignPlatformType
    
    init(from response: MyCampaignDTO) {
        self.id = response.id
        self.campaignId = response.campaignId
        self.userId = response.userId
        self.reviewerAnnouncementStatus = response.reviewerAnnouncementStatus
        self.statusLabel = response.statusLabel
        self.title = response.title
        self.benefit = response.benefit
        self.detailUrl = response.detailUrl
        self.imageUrl = response.imageUrl
        self.campaignPlatformImageUrl = response.campaignPlatformImageUrl
        self.applicantCount = response.applicantCount
        self.recruitCount = response.recruitCount
        self.snsPlatforms = response.snsPlatforms.map { SocialPlatformType(rawValue: $0) ?? .instagram }
        self.campaignSite = CampaignPlatformType(rawValue: response.campaignSite) ?? .revu
    }
    
    init(id: Int, campaignId: Int, userId: Int, reviewerAnnouncementStatus: String, statusLabel: String, title: String, benefit: String, detailUrl: String, imageUrl: String, campaignPlatformImageUrl: String, applicantCount: Int, recruitCount: Int, snsPlatforms: [SocialPlatformType], campaignSite: CampaignPlatformType) {
        self.id = id
        self.campaignId = campaignId
        self.userId = userId
        self.reviewerAnnouncementStatus = reviewerAnnouncementStatus
        self.statusLabel = statusLabel
        self.title = title
        self.benefit = benefit
        self.detailUrl = detailUrl
        self.imageUrl = imageUrl
        self.campaignPlatformImageUrl = campaignPlatformImageUrl
        self.applicantCount = applicantCount
        self.recruitCount = recruitCount
        self.snsPlatforms = snsPlatforms
        self.campaignSite = campaignSite
    }
    
    static let dummy: [MyCampaign] = [
        MyCampaign(
            id: 1,
            campaignId: 101,
            userId: 1,
            reviewerAnnouncementStatus: "ANNOUNCED",
            statusLabel: "선정됨",
            title: "[중앙선술] 부산대 최고 규모 선술집",
            benefit: "50,000원 식사권(대표메뉴 1개 필수 주문)",
            detailUrl: "https://example.com/campaign1",
            imageUrl: "https://picsum.photos/200",
            campaignPlatformImageUrl: "https://picsum.photos/50",
            applicantCount: 23,
            recruitCount: 12,
            snsPlatforms: [.instagram],
            campaignSite: .revu
        ),
        MyCampaign(
            id: 2,
            campaignId: 102,
            userId: 1,
            reviewerAnnouncementStatus: "PENDING",
            statusLabel: "검토중",
            title: "[와모아] 일주일에 10kg 감량 가능! 살이 쭉쭉 빠져요! 맛있는 효소 릴스 체험",
            benefit: "효소 1박스",
            detailUrl: "https://example.com/campaign2",
            imageUrl: "https://picsum.photos/201",
            campaignPlatformImageUrl: "https://picsum.photos/51",
            applicantCount: 135,
            recruitCount: 8,
            snsPlatforms: [.instagram, .youtube],
            campaignSite: .revu
        ),
        MyCampaign(
            id: 3,
            campaignId: 103,
            userId: 1,
            reviewerAnnouncementStatus: "COMPLETED",
            statusLabel: "완료",
            title: "[경기 가평군] 온델라카라반캠핑장 가평점",
            benefit: "(20만원 상당) 리버뷰 개인정원 카라반 숙박권 + 핀란드식 사우나 이용권",
            detailUrl: "https://example.com/campaign3",
            imageUrl: "https://picsum.photos/202",
            campaignPlatformImageUrl: "https://picsum.photos/52",
            applicantCount: 100,
            recruitCount: 3,
            snsPlatforms: [.youtube, .naverBlog],
            campaignSite: .revu
        )
    ]
} 
