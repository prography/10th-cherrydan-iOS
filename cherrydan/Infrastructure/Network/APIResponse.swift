struct APIResponse<T: Codable>: Codable {
    let code: Int
    let message: String
    let result: T
}

struct PageableResponse<T: Codable>: Codable {
    let content: [T]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
    let hasNext: Bool
    let hasPrevious: Bool
}

struct Validation: Codable {
    let isValid: Bool
}

struct SocialLoginResponse: Codable {
    let code: Int
    let message: String
    let result: SocialLoginResult
}

struct SocialLoginResult: Codable {
    struct Tokens: Codable {
        let accessToken: String
        let refreshToken: String
    }
    
    let tokens: Tokens
    let userId: Int
}

struct LoginResponse: Codable {
    let code: Int
    let message: String
    let result: LoginResult?
}

struct LoginResult: Codable {
    let accessToken: String
    let refreshToken: String
}

struct UserInfo: Codable {
    let name: String?
    let email: String?
    let platform: String
    
    init(name: String?, email: String?, platform: String) {
        self.name = name
        self.email = email
        self.platform = platform
    }
}

struct VersionResult: Codable {
    let minSupportedVersion: String
    let latestVersion: String
}

struct EmptyResult: Codable {}

