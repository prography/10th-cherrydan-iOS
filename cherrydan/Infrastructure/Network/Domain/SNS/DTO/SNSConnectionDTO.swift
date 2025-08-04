import Foundation

struct SNSConnectionDTO: Codable {
    let platform: String
    let isConnected: Bool
    let connectedAt: String?
    let url: String?
    let username: String?
    
    enum CodingKeys: String, CodingKey {
        case platform
        case isConnected = "is_connected"
        case connectedAt = "connected_at"
        case url
        case username
    }
}

struct SNSConnectionsResponseDTO: Codable {
    let connections: [SNSConnectionDTO]
} 