enum UserEndpoint: APIEndpoint {
    case getUser
    case deleteUser
    case patchFcmToken
    case getFcmTokens
    
    var path: String {
        switch self {
        case .getUser:
            "/user/me"
        case .deleteUser:
            "/user/me"
        case .patchFcmToken:
            "/user/fcm-token"
        case .getFcmTokens:
            "/user/fcm-tokens"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUser:
                .get
        case .deleteUser:
                .delete
        case .patchFcmToken:
                .patch
        case .getFcmTokens:
                .get
        }
    }
    
    var tokenType: TokenType { .accessToken }
}
