struct CampaignDTO: Codable {
    let id: Int
    let title: String?
    let detailUrl: String?
    let benefit: String?
    let reviewerAnnouncementStatus: String?
    let applicantCount: Int?
    let recruitCount: Int?
    let imageUrl: String?
    let campaignPlatformImageUrl: String?
    let campaignType: String?
    let competitionRate: Double?
    let campaignSite: String?
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
            campaignPlatformImageUrl: campaignPlatformImageUrl ?? "",
            campaignType: CampaignType(rawValue: campaignType ?? "REGION") ?? .product,
            competitionRate: competitionRate ?? 0.0,
            campaignSite: CampaignPlatformType(rawValue: campaignSite ?? "레뷰") ?? .chvu,
            snsPlatforms: snsPlatforms.map { SocialPlatformType(rawValue: $0) ?? .instagram }
        )
    }
}
