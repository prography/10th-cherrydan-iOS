struct MyCampaignDTO: Codable {
    let id: Int
    let campaignId: Int
    let campaignTitle: String?
    let campaignDetailUrl: String?
    let campaignImageUrl: String?
    let campaignPlatformImageUrl: String?
    let benefit: String?
    let applicantCount: Int?
    let recruitCount: Int?
    let snsPlatforms: [String]
    let reviewerAnnouncementStatus: String?
    let campaignSite: String?
    
    func toMyCampaign() -> MyCampaign {
        MyCampaign(
            id: id,
            campaignId: campaignId,
            campaignTitle: campaignTitle ?? "",
            campaignDetailUrl: campaignDetailUrl ?? "",
            campaignImageUrl: campaignImageUrl ?? "",
            campaignPlatformImageUrl: campaignPlatformImageUrl ?? "",
            benefit: benefit ?? "",
            applicantCount: applicantCount ?? 0,
            recruitCount: recruitCount ?? 0,
            snsPlatforms: snsPlatforms.compactMap { SocialPlatformType.from(displayName: $0) },
            reviewerAnnouncementStatus: reviewerAnnouncementStatus ?? "",
            campaignSite: campaignSite ?? ""
        )
    }
}
