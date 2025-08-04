struct MyCampaignDTO: Codable {
    let id: Int
    let campaignId: Int
    let userId: Int
    let reviewerAnnouncementStatus: String?
    let statusLabel: String?
    let title: String?
    let benefit: String?
    let campaignPlatformImageUrl: String?
    let detailUrl: String?
    let imageUrl: String?
    let applicantCount: Int?
    let recruitCount: Int?
    let campaignSiteNameKr: String?
    let campaignSiteNameEn: String?
    let campaignSiteUrl: String?
    let snsPlatforms: [String]
    
    func toMyCampaign() -> MyCampaign {
        MyCampaign(
            id: id,
            campaignId: campaignId,
            userId: userId,
            reviewerAnnouncementStatus: reviewerAnnouncementStatus ?? "",
            statusLabel: statusLabel ?? "",
            title: title ?? "",
            benefit: benefit ?? "",
            detailUrl: detailUrl ?? "",
            imageUrl: imageUrl ?? "",
            applicantCount: applicantCount ?? 1,
            recruitCount: recruitCount ?? 1,
            campaignSite: CampaignPlatform(
                siteNameKr: campaignSiteNameKr ?? "레뷰",
                siteNameEn: campaignSiteNameEn ?? "revu",
                cdnUrl: campaignSiteUrl ?? ""
            ),
            snsPlatforms: snsPlatforms.map { SocialPlatformType(rawValue: $0) ?? .instagram }
        )
    }
}
