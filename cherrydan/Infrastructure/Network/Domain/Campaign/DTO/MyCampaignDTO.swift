struct MyCampaignDTO: Codable {
    let id: Int
    let userId: Int
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
    let statusLabel: String
    let campaignSite: String?
    
    func toMyCampaign() -> MyCampaign {
        MyCampaign(
            id: id,
            campaignId: campaignId,
            reviewerAnnouncementStatus: reviewerAnnouncementStatus ?? "",
            statusLabel: CampaignStatusType.allCases.first(where:{ $0.apiValue == statusLabel}) ?? .apply,
            title: campaignTitle ?? "",
            benefit: benefit ?? "",
            detailUrl: campaignDetailUrl ?? "",
            imageUrl: campaignImageUrl ?? "",
            campaignPlatformImageUrl: campaignPlatformImageUrl ?? "",
            applicantCount: applicantCount ?? 0,
            recruitCount: recruitCount ?? 0,
            snsPlatforms: snsPlatforms.compactMap { snsPlatform in
                SNSPlatformType.allCases.first(where:{ $0.displayName == snsPlatform})
            },
            campaignSite: campaignSite ?? ""
        )
    }
}
