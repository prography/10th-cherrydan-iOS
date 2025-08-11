import Foundation

// MARK: - User Keywords DTOs

struct UserKeywordResponseDTO: Codable {
    let id: Int
    let keyword: String
}

// MARK: - Keyword Notification DTOs

struct KeywordNotificationDTO: Codable {
    let id: Int
    let keyword: String
    let isRead: Bool
    let campaignCount: Int
    let alertDate: String
    
    func toKeywordNotification() -> KeywordNotification {
        return KeywordNotification(
            id: id,
            keyword: keyword,
            alertDate: alertDate,
            campaignCount: campaignCount,
            isRead: isRead
        )
    }
}

// MARK: - Extensions for Domain Conversion

extension UserKeywordResponseDTO {
    func toUserKeyword() -> UserKeyword {
        return UserKeyword(
            id: id,
            keyword: keyword
        )
    }
}
