import Foundation

struct SNSConnection {
    let platform: String
    let isConnected: Bool
    let connectedAt: Date?
    let url: String?
    let username: String?
}

extension SNSConnectionDTO {
    func toSNSConnection() -> SNSConnection {
        return SNSConnection(
            platform: platform,
            isConnected: isConnected,
            connectedAt: connectedAt?.toDate(),
            url: url,
            username: username
        )
    }
}

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        
        // 첫 번째 포맷으로 시도
        if let date = formatter.date(from: self) {
            return date
        }
        
        // 두 번째 포맷으로 시도 (초단위 정확도)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter.date(from: self) {
            return date
        }
        
        // ISO 8601 포맷으로 시도
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
} 