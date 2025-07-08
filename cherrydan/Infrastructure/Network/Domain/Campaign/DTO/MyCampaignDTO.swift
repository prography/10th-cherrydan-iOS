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
    
    func toMyCampaign() -> MyCampaign {
        MyCampaign(
            id: id,
            campaignId: campaignId,
            userId: userId,
            reviewerAnnouncementStatus: reviewerAnnouncementStatus,
            statusLabel: statusLabel,
            title: title,
            benefit: benefit,
            detailUrl: detailUrl,
            imageUrl: imageUrl,
            campaignPlatformImageUrl: campaignPlatformImageUrl,
            applicantCount: applicantCount,
            recruitCount: recruitCount,
            snsPlatforms: snsPlatforms.map { SocialPlatformType(rawValue: $0) ?? .instagram },
            campaignSite: CampaignPlatformType(rawValue: campaignSite) ?? .revu
        )
    }
}
