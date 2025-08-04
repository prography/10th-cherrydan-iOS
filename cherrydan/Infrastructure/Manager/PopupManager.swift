import SwiftUI

final class PopupManager: ObservableObject {
    static let shared = PopupManager()
    
    private init() {}
    
    @Published var popupPresented = false
    
    private(set) var currentPopupType: PopupType?
    
    func show(_ type: PopupType) {
        currentPopupType = type
        popupPresented = true
    }
}
