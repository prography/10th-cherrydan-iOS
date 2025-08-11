struct MyCampaignsResponse: Codable {
    let apply: [MyCampaignDTO]
    let selected: [MyCampaignDTO]
    let nonSelected: [MyCampaignDTO]
    let registered: [MyCampaignDTO]
    let ended: [MyCampaignDTO]
    let count: String
}
