struct ActivityNotification: Identifiable, Equatable, Codable {
    let id: Int
    let campaignId: Int
    let campaignTitle: String
    let applyEndDate: String
    let alertDate: String
    let isRead: Bool
    let dday: Int
}
