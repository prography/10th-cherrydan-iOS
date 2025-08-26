struct UserDTO: Codable {
    let email: String
    let name: String?
    let nickname: String?
    let birthYear: Int?
    let gender: String?
    let tosAgreements: [Bool]
    
    func toUser() -> User {
        User(
            email: email,
            name: name ?? "회원",
            nickname: nickname ?? "회원",
            birthYear:  birthYear ?? -1
        )
    }
}

struct FcmTokensDTO: Codable {
    let deviceId: Int
    let fcmToken: String?
    let deviceType: String?
    let deviceModel: String?
    let appVersion: String?
    let osVersion: String?
    let isActive: Bool?
    let isAllowed: Bool?
    let lastUpdated: String?
    let createdAt: String?
    let updatedAt: String?
}
