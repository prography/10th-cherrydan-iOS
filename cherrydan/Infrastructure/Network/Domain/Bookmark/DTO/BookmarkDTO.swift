import Foundation

// MARK: - Bookmark Response
struct BookmarkResponseDTO: Codable {
    let id: Int
    let campaignId: Int
    let campaignTitle: String?
    let campaignDetailUrl: String?
    let campaignImageUrl: String?
    let campaignPlatformImageUrl: String?
    let benefit: String?
    let applicantCount: Int?
    let recruitCount: Int?
    let snsPlatforms: [String]?
    let reviewerAnnouncementStatus: String?
    let campaignSite: String?
}

// MARK: - Bookmark Split Response (내 북마크 목록 조회용)
struct BookmarkSplitResponseDTO: Codable {
    let open: PageListResponseDTO<BookmarkResponseDTO>?
    let closed: PageListResponseDTO<BookmarkResponseDTO>?
}

// MARK: - Page List Response for Bookmark
struct PageListResponseDTO<T: Codable>: Codable {
    let content: [T]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let hasNext: Bool
    let hasPrevious: Bool
}