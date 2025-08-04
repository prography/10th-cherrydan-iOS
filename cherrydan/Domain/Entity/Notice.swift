import Foundation
import SwiftUI

// 실제 사용할 모델
struct Notice: Identifiable, Equatable {
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
    
    // 기존 UI와 호환을 위한 computed property들
    var type: NoticeType {
        if isHot {
            return .hot
        }
        
        switch category.lowercased() {
        case "notice", "공지":
            return .notice
        case "event", "이벤트":
            return .event
        case "tip", "팁":
            return .tip
        default:
            return .normal
        }
    }
    
    var views: Int {
        return viewCount
    }
    
    var likes: Int {
        return empathyCount
    }
    
    var date: String {
        return formatDate(publishedAt)
    }
    
    // NoticeBoardDTO에서 변환하는 이니셜라이저
    init(from dto: NoticeBoardDTO) {
        self.id = dto.id
        self.title = dto.title
        self.content = dto.content
        self.imageUrls = dto.imageUrls
        self.category = dto.category
        self.isHot = dto.isHot
        self.viewCount = dto.viewCount
        self.empathyCount = dto.empathyCount
        self.publishedAt = dto.publishedAt
        self.createdAt = dto.createdAt
    }
    
    // 직접 생성용 이니셜라이저 (더미 데이터, 테스트 등)
    init(
        id: Int = 0,
        title: String,
        content: String,
        imageUrls: [String] = [],
        category: String = "",
        isHot: Bool = false,
        viewCount: Int,
        empathyCount: Int,
        publishedAt: String,
        createdAt: String? = nil
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.imageUrls = imageUrls
        self.category = category
        self.isHot = isHot
        self.viewCount = viewCount
        self.empathyCount = empathyCount
        self.publishedAt = publishedAt
        self.createdAt = createdAt ?? publishedAt
    }
    
    // 기존 호환을 위한 이니셜라이저
    init(type: NoticeType, title: String, content: String, date: String, views: Int, likes: Int) {
        self.id = 0
        self.title = title
        self.content = content
        self.imageUrls = []
        self.category = type.rawValue
        self.isHot = (type == .hot)
        self.viewCount = views
        self.empathyCount = likes
        self.publishedAt = date
        self.createdAt = date
    }
    
    // 날짜 포맷팅 함수
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy.MM.dd"
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

enum NoticeType: String, CaseIterable {
    case notice, event, tip, hot, normal
    
    var label: String? {
        switch self {
        case .notice: return "공지"
        case .event: return "Event"
        case .tip: return "Tip"
        case .hot: return "Hot"
        default: return nil
        }
    }
    
    var labelBackgroundColor: Color {
        switch self {
        case .notice, .event, .tip: return .gray5
        case .hot: return .mPink2
        default: return .clear
        }
    }
    
    var labelTextColor: Color {
        switch self {
        case .notice, .event, .tip: return .pBlue
        case .hot: return .gray0
        default: return .clear
        }
    }
} 