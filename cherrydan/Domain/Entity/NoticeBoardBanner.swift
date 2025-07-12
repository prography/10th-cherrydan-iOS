struct NoticeBoardBanner: Codable, Hashable {
    let id: Int
    let title: String
    let imageUrl: String
    let bannerType: String
    let linkType: String
    let targetId: Int
    let targetUrl: String
    let updatedAt: String
}
