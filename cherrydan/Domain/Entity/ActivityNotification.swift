import Foundation

struct ActivityNotification: Identifiable, Equatable, Codable {
    let campaignStatusId: Int
    let notificationType: String
    let notificationBoldText: String
    let fullText: String
    var isRead: Bool
    let createdDate: String
    
    var id: Int { campaignStatusId }
}
