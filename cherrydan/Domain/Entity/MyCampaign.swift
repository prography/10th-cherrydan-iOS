struct MyCampaign: Identifiable, Equatable {
    let id: Int
    let campaignId: Int
    let reviewerAnnouncementStatus: String
    let statusLabel: CampaignStatusType
    let title: String
    let benefit: String
    let detailUrl: String
    let imageUrl: String
    let campaignPlatformImageUrl: String
    let applicantCount: Int
    let recruitCount: Int
    let snsPlatforms: [SNSPlatformType]   // JSON은 [String]인데, 앱에서 enum으로 매핑
    let campaignSite: String
}
