import Foundation
import SwiftUI
import AuthenticationServices
import KakaoSDKUser
import NaverThirdPartyLogin
import GoogleSignIn

@MainActor
class OnboardingViewModel: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var recentLoggedInPlatform: LoginPlatform? = .apple
    
    let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    private let auth: AuthRepository
    
    override init() {
        self.auth = AuthRepository()
        super.init()
        setupNaverLogin()
    }
    
    init(auth: AuthRepository) {
        self.auth = auth
        super.init()
        setupNaverLogin()
    }
    
    private func setupNaverLogin() {
        instance?.delegate = self
    }
    
    func performNaverLogin() async {
        isLoading = true
        errorMessage = nil
        
        instance?.requestThirdPartyLogin()
    }
    
    func performKakaoLogin() async {
        isLoading = true
        errorMessage = nil
        
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Kakao login error: \(error)")
                Task { @MainActor in
                    self.errorMessage = "카카오 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"
                    self.isLoading = false
                }
            } else {
                Task { @MainActor in
                    guard let oauthToken = oauthToken else {
                        self.errorMessage = "카카오 토큰을 가져올 수 없습니다."
                        self.isLoading = false
                        return
                    }
                    
                    await self.handleSocialLogin(.kakao, oauthToken.accessToken)
                }
            }
        }
    }
    
    func performGoogleLogIn() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] signInResult, error in
            guard let self else { return }
            if let error = error {
                if let error = error as? GIDSignInError {
                    switch error.code {
                    case .canceled:
                        print("구글 로그인 도중에 취소됨")
                    default:
                        print("구글 로그인 도중에 취소됨")
                    }
                } else {
                    print("구글 로그인 도중에 취소됨")
                }
                
            } else if let signInResult {
                guard let idToken = signInResult.user.idToken?.tokenString else {
                    return
                }
                
                Task {
                    await self.handleSocialLogin(.google, idToken)
                }
            }
        }
    }
    
    func performAppleLogin(_ result: ASAuthorization) async {
        isLoading = true
        errorMessage = nil
        
        guard let appleIDCredential = result.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = appleIDCredential.identityToken,
              let idToken = String(data: identityTokenData, encoding: .utf8) else {
            errorMessage = "애플 로그인 인증 정보를 가져올 수 없습니다."
            isLoading = false
            return
        }
        
        await handleSocialLogin(.apple, idToken)
    }
    
    private func handleSocialLogin(_ platform: LoginPlatform, _ token: String) async {
        do {
            let response = try await auth.socialLogin(platform.rawValue, token)
            
            if response.code == 200 {
                AuthManager.shared.login(response.result)
                
                recentLoggedInPlatform = platform
            } else {
                errorMessage = response.message
            }
        } catch {
            errorMessage = "\(platform.title) 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"
            print("\(platform.rawValue) login error: \(error)")
            isLoading = false
        }
        
        isLoading = false
    }
}

// MARK: - NaverThirdPartyLoginConnectionDelegate
extension OnboardingViewModel: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("네이버 로그인 성공 - 인증 코드")
        handleNaverLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("네이버 로그인 성공 - 리프레시 토큰으로 액세스 토큰 갱신")
        handleNaverLoginSuccess()
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("네이버 로그아웃 완료")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("네이버 로그인 실패: \(error.localizedDescription)")
        Task { @MainActor in
            self.errorMessage = "네이버 로그인 중 오류가 발생했습니다: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
    
    private func handleNaverLoginSuccess() {
        Task { @MainActor in
            do {
                guard let accessToken = instance?.accessToken else {
                    self.errorMessage = "네이버 액세스 토큰을 가져올 수 없습니다."
                    self.isLoading = false
                    return
                }
                
                await self.handleSocialLogin(.naver, accessToken)
            }
        }
    }
}
