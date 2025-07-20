enum AuthEndpoint: APIEndpoint {
    case refresh
    case authLogout
    case socialLogin(String)
    
    var path: String {
        switch self {
        case .refresh:
            "/auth/refresh"
        case .authLogout:
            "/auth/logout"
        case .socialLogin(let provider):
            "/auth/\(provider)/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .refresh:
                .post
        case .authLogout:
                .post
        case .socialLogin:
                .post
        }
    }
    
    var tokenType: TokenType {
        switch self {
        case .socialLogin, .refresh:
                .none
        default:
                .accessToken
        }
    }
}
