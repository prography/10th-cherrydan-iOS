struct CampaignDTO: Codable {
    let id: Int
    let title: String?
    let detailUrl: String?
    let benefit: String?
    let reviewerAnnouncementStatus: String?
    let applicantCount: Int?
    let recruitCount: Int?
    let imageUrl: String?
    let isBookmarked: Bool?
    let campaignPlatformImageUrl: String?
    let campaignType: String?
    let competitionRate: Double?
    let campaignSite: String? // 추후 fade-out 예정 -> campaignSiteKr과 동일
    let campaignSiteKr: String?
    let campaignSiteEn: String?
    let campaignSiteUrl: String?
    let snsPlatforms: [String]
    
    func toCampaign() -> Campaign {
        Campaign(
            id: id,
            title: title ?? "제목",
            detailUrl: detailUrl ?? "",
            benefit: benefit ?? "",
            reviewerAnnouncementStatus: reviewerAnnouncementStatus ?? "",
            applicantCount: applicantCount ?? 0,
            recruitCount: recruitCount ?? 0,
            imageUrl: imageUrl ?? "",
            isBookmarked: isBookmarked ?? false,
            campaignType: CampaignType(rawValue: campaignType ?? "REGION") ?? .product,
            competitionRate: competitionRate ?? 0.0,
            campaignSite: CampaignPlatform(
                siteNameKr: campaignSiteKr ?? "레뷰",
                siteNameEn: campaignSiteEn ?? "revu",
                cdnUrl: campaignSiteUrl ?? ""
            ),
            snsPlatforms: snsPlatforms.compactMap { SocialPlatformType.from(displayName: $0) }
        )
    }
}
