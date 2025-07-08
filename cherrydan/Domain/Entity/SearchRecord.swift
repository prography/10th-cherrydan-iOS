struct SearchRecord: Identifiable, Codable {
    let id: String
    let text: String
    let createdAt: String
    
    init(id: String, text: String, createdAt: String) {
        self.id = id
        self.text = text
        self.createdAt = createdAt
    }
}
