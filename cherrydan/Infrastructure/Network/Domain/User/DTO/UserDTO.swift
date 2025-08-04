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
