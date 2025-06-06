import SwiftUI
import Combine

@MainActor
class TabBarManager: ObservableObject {
    static let shared = TabBarManager()
    
    @Published var isHidden = false
    
    private init() {}
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        withAnimation(.fastSpring) {
            isHidden = false
        }
    }
}
