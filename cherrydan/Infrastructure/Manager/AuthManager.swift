import Foundation
import Combine

public enum UserDefaultKeys {
    static let isLoggedIn = "isLoggedIn"
    static let isDarkMode = "isDarkMode"
}

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published private(set) var isLoggedIn: Bool = true
    
    private init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: UserDefaultKeys.isLoggedIn)
    }
    
    func login(_ result: SocialLoginResult) {
        isLoggedIn = true
        
        KeychainManager.shared.saveToken(result.tokens.accessToken)
        KeychainManager.shared.saveRefreshToken(result.tokens.refreshToken)
        
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.isLoggedIn)
    }
    
    func logout() {
        isLoggedIn = false
//        AuthRepository.logout()
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isLoggedIn)
        
        KeychainManager.shared.clearToken()
    }
}
