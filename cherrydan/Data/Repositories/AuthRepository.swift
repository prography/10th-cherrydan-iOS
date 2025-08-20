import Foundation
import UIKit
import FirebaseMessaging
import UserNotifications

class AuthRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func socialLogin(_ provider: String,_ token: String, userInfo: UserInfo?) async throws -> SocialLoginResponse {
        var fcmToken = KeychainManager.shared.getFcmToken()
        if fcmToken == nil || fcmToken?.isEmpty == true {
            // 로그인 직전 강제 토큰 획득 시도
            fcmToken = await Messaging.fetchFCMToken()
            if let token = fcmToken, token.isEmpty == false {
                KeychainManager.shared.saveFcmToken(token)
            }
        }
        
        let deviceModel = await UIDevice.current.modelName
        
        // 알림 권한 상태 확인
        let notificationSettings = await UNUserNotificationCenter.current().notificationSettings()
        let isNotificationAllowed = notificationSettings.authorizationStatus == .authorized
    
        var params: [String: String] = [
            "accessToken": token,
            "fcmToken": fcmToken ?? "",
            "deviceType": "iOS",
            "deviceModel": deviceModel,
            "osVersion": "\(ProcessInfo.processInfo.operatingSystemVersionString)",
            "appVersion": "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")",
            "isAllowed": isNotificationAllowed ? "true" : "false"
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
