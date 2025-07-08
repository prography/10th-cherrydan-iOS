enum UserEndpoint: APIEndpoint {
    case getUser
    case deleteUser
    
    var path: String {
        switch self {
        case .getUser:
            "/user/me"
        case .deleteUser:
            "/user/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
                .get
        case .deleteUser:
                .delete
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
