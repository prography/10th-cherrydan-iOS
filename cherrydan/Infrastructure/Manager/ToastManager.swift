import SwiftUI

final class ToastManager: ObservableObject {
    static let shared = ToastManager()

    private init() {}
    
    @Published var toastPresented = false
    
    private(set) var currentToastType: ToastType?
    
    func show(_ type: ToastType, isDelayNeeded: Bool = false) {
        if isDelayNeeded {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self._show(type)
            }
        } else {
            _show(type)
        }
    }
    
    private func _show(_ type: ToastType) {
        currentToastType = type
        
        // 이미 토스트가 표시중이라면 먼저 리셋 후 새로운 토스트 표시
        if toastPresented {
            toastPresented = false
            
            // 짧은 지연 후 새로운 토스트 표시 (SwiftUI 상태 업데이트 보장)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.toastPresented = true
            }
        } else {
            toastPresented = true
        }
    }
    
    func reset() {
        toastPresented = false
        currentToastType = nil
    }
}
