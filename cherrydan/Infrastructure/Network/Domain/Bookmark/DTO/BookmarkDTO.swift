struct BookmarkListResponseDTO: Codable {
    let open: PageableResponse<MyCampaignDTO>
    let closed: PageableResponse<MyCampaignDTO>
}
