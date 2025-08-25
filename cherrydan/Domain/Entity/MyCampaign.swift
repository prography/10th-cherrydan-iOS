struct MyCampaign: Identifiable, Equatable {
    let id: Int
    let campaignId: Int
    let reviewerAnnouncementStatus: String
    let title: String
    let benefit: String
    let detailUrl: String
    let imageUrl: String
    let campaignPlatformImageUrl: String
    let applicantCount: Int
    let recruitCount: Int
    let snsPlatforms: [SNSPlatformType]
    let campaignSite: String
}
