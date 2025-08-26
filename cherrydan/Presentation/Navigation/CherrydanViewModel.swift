import Foundation
import SwiftUI

@MainActor
class CherrydanViewModel: ObservableObject {
    @Published var isInitializing = true
    
    private let myPageRepository: MyPageRepository
    
    private var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.2"
    }
    
    init(myPageRepository: MyPageRepository =  MyPageRepository()) {
        self.myPageRepository = myPageRepository
        initialize()
    }
    
    private func initialize() {
        Task {
            do {
                let response = try await myPageRepository.getVersion()
                handleVersionCheck(
                    newVersion: response.latestVersion,
                    minVersion: response.minSupportedVersion
                )
                await handleAuthState()
            } catch {
                print("Failed to get version info: \(error)")
            }
            
            isInitializing = false
        }
    }
    
    private func handleAuthState() async {
        let refreshSuccess = await TokenManager.shared.ensureValidToken()
        if refreshSuccess {
            AuthManager.shared.isLoggedIn = true
        } else {
            print("리프레시 토큰 존재 & 재발급 실패하여 자동 로그아웃")
            AuthManager.shared.logout()
        }
    }
    
    private func handleVersionCheck(newVersion: String, minVersion: String) {
        let moveToAppStore = {
            if let url = URL(string: "https://apps.apple.com/kr/app/%EC%B2%B4%EB%A6%AC%EB%8B%A8/id6748566686") {
                UIApplication.shared.open(url)
            }
        }
        
        // 현재 버전이 최소 지원 버전보다 낮은 경우 - 필수 업데이트
        if currentAppVersion.isVersionLower(than: minVersion) {
            PopupManager.shared.show(.updateMandatory(onClick: moveToAppStore))
        }
        
        // 현재 버전이 최신 버전보다 낮은 경우 - 선택적 업데이트
        else if currentAppVersion.isVersionLower(than: newVersion) {
            PopupManager.shared.show(.updateOptional(onClick: moveToAppStore))
        }
    }
}
