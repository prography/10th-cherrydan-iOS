import Foundation

class AuthRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func socialLogin(_ provider: String,_ token: String, userInfo: UserInfo?) async throws -> SocialLoginResponse {
        let fcmToken = KeychainManager.shared.getFcmToken()
        var params: [String: Any] = [
            "accessToken": token,
            "fcmToken": fcmToken,
            "deviceType": "iOS"
        ]
        
        // 사용자 정보가 있는 경우 추가
        if let userInfo = userInfo {
            if let name = userInfo.name {
                params["name"] = name
            }
            if let email = userInfo.email {
                params["email"] = email
            }
        }
        
        return try await networkAPI.request(AuthEndpoint.socialLogin(provider), parameters: params)
    }
    
    func refreshToken() async throws -> Data? {
        return try await networkAPI.request(AuthEndpoint.refresh)
    }
    
    func logout() async throws -> Data? {
        return try await networkAPI.request(AuthEndpoint.authLogout)
    }
}
