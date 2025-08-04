enum SNSEndpoint: APIEndpoint {
    case naverVerify
    case oauthCallback(platform: String)
    case oauthAuthUrl(platform: String)
    case getConnections
    case disconnect(platform: String)
    
    var path: String {
        switch self {
        case .naverVerify:
            "/sns/naver/verify"
        case .oauthCallback(let platform):
            "/sns/oauth/\(platform)/callback"
        case .oauthAuthUrl(let platform):
            "/sns/oauth/\(platform)/auth-url"
        case .getConnections:
            "/sns/connections"
        case .disconnect(let platform):
            "/sns/disconnect/\(platform)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .naverVerify:
            .post
        case .oauthCallback, .oauthAuthUrl, .getConnections:
            .get
        case .disconnect:
            .delete
        }
    }
    
    var tokenType: TokenType { .accessToken }
} 