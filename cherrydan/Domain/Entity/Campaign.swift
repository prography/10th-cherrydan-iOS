struct Campaign: Identifiable, Equatable {
    let id: Int
    let title: String
    let detailUrl: String
    let benefit: String
    let reviewerAnnouncementStatus: String
    let applicantCount: Int
    let recruitCount: Int
    let imageUrl: String
    var isBookmarked: Bool
    let campaignType: CampaignType  // 열거형 사용
    let competitionRate: Double
    let campaignSite: CampaignPlatform
    let snsPlatforms: [SocialPlatformType]
}
