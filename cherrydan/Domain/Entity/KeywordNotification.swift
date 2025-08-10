struct KeywordNotification: Identifiable, Codable, Equatable {
    let id: Int
    let keyword: String
    let alertDate: String
    let campaignCount: Int
    let isRead: Bool
}
