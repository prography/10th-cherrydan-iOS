enum MyPageEndpoint: APIEndpoint {
    case getVersion
//    case patchAllPushSetting
//    case postInquiry
//    case getInquiries
//    case putPushSetting
//    case getPushSetting
//    case putTos
//    case getTos
    
    
    var path: String {
        switch self {
        case .getVersion:
            "/mypage/version"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getVersion:
                .get
        }
    }
    
    var tokenType: TokenType {
        .none
    }
}
