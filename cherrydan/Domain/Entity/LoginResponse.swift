import Foundation

struct LoginResponse: Codable {
    let code: Int
    let message: String
    let result: LoginResult?
}

struct LoginResult: Codable {
    let accessToken: String
    let refreshToken: String
} 