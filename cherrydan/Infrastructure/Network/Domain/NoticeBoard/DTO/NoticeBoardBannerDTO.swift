struct NoticeBoardBannerDTO: Codable {
    let id: Int
    let title: String?
    let imageUrl: String?
    let bannerType: String?
    let linkType: String?
    let targetId: Int?
    let targetUrl: String?
    let updatedAt: String?
    
    func toNoticeBoardBanner() -> NoticeBoardBanner {
        return NoticeBoardBanner(
            id: self.id,
            title: self.title ?? "",
            imageUrl: self.imageUrl ?? "",
            bannerType: self.bannerType ?? "",
            linkType: self.linkType ?? "",
            targetId: self.targetId ?? -1,
            targetUrl: self.targetUrl ?? "",
            updatedAt: self.updatedAt ?? ""
        )
    }
}
