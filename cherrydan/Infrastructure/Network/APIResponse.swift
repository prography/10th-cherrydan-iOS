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

struct EmptyResult: Codable {}

