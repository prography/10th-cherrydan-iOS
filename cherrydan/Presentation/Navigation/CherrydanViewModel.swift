import Foundation
import SwiftUI

@MainActor
class CherrydanViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    
    private let myPageRepository: MyPageRepository
    
    private var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.2.5"
    }
    
    init(myPageRepository: MyPageRepository =  MyPageRepository()) {
        self.myPageRepository = myPageRepository
        
        checkAppVersion()
    }
    
    func checkAppVersion() {
        isLoading = true
        
        Task {
            do {
                let response = try await myPageRepository.getVersion()
                handleVersionCheck(
                    newVersion: response.latestVersion,
                    minVersion: response.minSupportedVersion
                )
                isLoading = false
            } catch {
                print(error)
                isLoading = false
            }
        }
    }
    
    private func handleVersionCheck(newVersion: String, minVersion: String) {
        let moveToAppStore = {
            if let url = URL(string: "https://apps.apple.com/kr/app/tyte/id6723872988") {
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
