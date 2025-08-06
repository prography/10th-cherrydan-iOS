import Foundation
import Combine
import KakaoSDKUser
import NaverThirdPartyLogin
import GoogleSignIn

public enum UserDefaultKeys {
    static let isDarkMode = "isDarkMode"
    static let lastLoggedInPlatform = "lastLoggedInPlatform"
    static let userNickname = "userNickname"
}

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published private(set) var isLoggedIn: Bool = false
    @Published private(set) var isGuestMode: Bool = false
    @Published private(set) var lastLoggedInPlatform: LoginPlatform?
    @Published private(set) var userNickname: String = "회원"
    
    private init() {
        // 마지막 로그인 플랫폼 불러오기
        if let platformString = UserDefaults.standard.string(forKey: UserDefaultKeys.lastLoggedInPlatform) {
            self.lastLoggedInPlatform = LoginPlatform(rawValue: platformString)
        }
        
        // 사용자 닉네임 불러오기
        self.userNickname = UserDefaults.standard.string(forKey: UserDefaultKeys.userNickname) ?? "회원"
    }
    
    func enterGuestMode() {
        isLoggedIn = true
        isGuestMode = true
    }
    
    func leaveGuestMode(){
        isGuestMode = false
        isLoggedIn = false
    }
    
    func login(_ result: SocialLoginResult, platform: LoginPlatform, nickname: String? = nil) {
        isLoggedIn = true
        lastLoggedInPlatform = platform
        
        // 닉네임 설정 (nil이거나 빈 문자열인 경우 "회원"으로 설정)
        let finalNickname = nickname?.isEmpty == false ? nickname! : "회원"
        userNickname = finalNickname
        
        KeychainManager.shared.saveTokens(result.tokens.accessToken, result.tokens.refreshToken)
        
        UserDefaults.standard.set(platform.rawValue, forKey: UserDefaultKeys.lastLoggedInPlatform)
        UserDefaults.standard.set(finalNickname, forKey: UserDefaultKeys.userNickname)
    }
    
    func login(_ accessToken: String, _ refreshToken: String, _ nickname: String? = nil) {
        isLoggedIn = true
        
        KeychainManager.shared.saveTokens(accessToken, refreshToken)
        
        if let nickname {
            let finalNickname = nickname.isEmpty ? "회원" : nickname
            userNickname = finalNickname
            UserDefaults.standard.set(finalNickname, forKey: UserDefaultKeys.userNickname)
        }
    }
    
    func logout() {
        if let platform = lastLoggedInPlatform {
            performPlatformLogout(platform)
        }
        
        isLoggedIn = false
        lastLoggedInPlatform = nil
        userNickname = "회원"
        
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.lastLoggedInPlatform)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userNickname)
        
        KeychainManager.shared.clearTokens()
    }
    
    func updateNickname(_ nickname: String) {
        let finalNickname = nickname.isEmpty ? "회원" : nickname
        userNickname = finalNickname
        UserDefaults.standard.set(finalNickname, forKey: UserDefaultKeys.userNickname)
    }
    
    private func performPlatformLogout(_ platform: LoginPlatform) {
        switch platform {
        case .kakao:
            UserApi.shared.logout { error in
                if let error = error {
                    print("카카오 로그아웃 실패: \(error)")
                } else {
                    print("카카오 로그아웃 성공")
                }
            }
        case .naver:
            NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
        case .google:
            GIDSignIn.sharedInstance.signOut()
        case .apple:
            // 애플 로그인은 별도 로그아웃 처리 불필요
            break
        }
    }
}
