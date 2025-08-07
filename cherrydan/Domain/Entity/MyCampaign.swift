struct MyCampaign: Identifiable, Equatable {
    let id: Int
    let campaignId: Int
    let campaignTitle: String
    let campaignDetailUrl: String
    let campaignImageUrl: String
    let campaignPlatformImageUrl: String
    let benefit: String
    let applicantCount: Int
    let recruitCount: Int
    let snsPlatforms: [SocialPlatformType]
    let reviewerAnnouncementStatus: String
    let campaignSite: String
} 
