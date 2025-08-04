import Foundation

struct NoticeBoardDTO: Codable {
    let id: Int
    let title: String
    let content: String
    let imageUrls: [String]
    let category: String
    let isHot: Bool
    let viewCount: Int
    let empathyCount: Int
    let publishedAt: String
    let createdAt: String
} 
