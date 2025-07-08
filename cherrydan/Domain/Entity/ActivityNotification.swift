struct ActivityNotification: Identifiable, Equatable, Codable {
    let id: Int
    let notificationType: String
    let notificationBoldText: String
    let fullText: String
    let isRead: Bool
    let createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "campaignStatusId"
        case notificationType, notificationBoldText, fullText, isRead, createdDate
    }
}
