import Foundation
import Combine
import KakaoSDKUser
import NaverThirdPartyLogin
import GoogleSignIn

public enum UserDefaultKeys {
    static let isLoggedIn = "isLoggedIn"
    static let isDarkMode = "isDarkMode"
    static let lastLoggedInPlatform = "lastLoggedInPlatform"
    static let userNickname = "userNickname"
}

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published private(set) var isLoggedIn: Bool = true
    @Published private(set) var lastLoggedInPlatform: LoginPlatform?
    @Published private(set) var userNickname: String = "회원"
    
    private init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: UserDefaultKeys.isLoggedIn)
        
        // 마지막 로그인 플랫폼 불러오기
        if let platformString = UserDefaults.standard.string(forKey: UserDefaultKeys.lastLoggedInPlatform) {
            self.lastLoggedInPlatform = LoginPlatform(rawValue: platformString)
        }
        
        // 사용자 닉네임 불러오기
        self.userNickname = UserDefaults.standard.string(forKey: UserDefaultKeys.userNickname) ?? "회원"
    }
    
    func login(_ result: SocialLoginResult, platform: LoginPlatform, nickname: String? = nil) {
        isLoggedIn = true
        lastLoggedInPlatform = platform
        
        // 닉네임 설정 (nil이거나 빈 문자열인 경우 "회원"으로 설정)
        let finalNickname = nickname?.isEmpty == false ? nickname! : "회원"
        userNickname = finalNickname
        
        KeychainManager.shared.saveToken(result.tokens.accessToken)
        KeychainManager.shared.saveRefreshToken(result.tokens.refreshToken)
        
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isLoggedIn)
        UserDefaults.standard.set(platform.rawValue, forKey: UserDefaultKeys.lastLoggedInPlatform)
        UserDefaults.standard.set(finalNickname, forKey: UserDefaultKeys.userNickname)
    }
    
    func logout() {
        // 플랫폼별 SDK 로그아웃 처리
        if let platform = lastLoggedInPlatform {
            performPlatformLogout(platform)
        }
        
        isLoggedIn = false
        lastLoggedInPlatform = nil
        userNickname = "회원"
        
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.lastLoggedInPlatform)
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userNickname)
        
        KeychainManager.shared.clearToken()
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
