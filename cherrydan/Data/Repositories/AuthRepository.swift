import Foundation

class AuthRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func socialLogin(_ provider: String,_ token: String) async throws -> SocialLoginResponse {
        let fcmToken = KeychainManager.shared.getFcmToken()
        let params = ["accessToken": token,
                      "fcmToken": fcmToken,
                      "deviceType": "iOS"]
        
        return try await networkAPI.request(.socialLogin(provider), parameters: params as [String : Any])
    }
    
    func refreshToken() async throws -> Data? {
        return try await networkAPI.request(.refresh)
    }
    
    func logout() async throws -> Data? {
        return try await networkAPI.request(.authLogout)
    }
}
