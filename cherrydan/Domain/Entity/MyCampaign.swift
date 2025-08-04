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
    let applicantCount: Int
    let recruitCount: Int
    let campaignSite: CampaignPlatform
    let snsPlatforms: [SocialPlatformType]
} 
