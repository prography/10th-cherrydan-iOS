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

// MARK: - Custom View Modifier
struct HideTabBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                TabBarManager.shared.hide()
            }
            .onDisappear {
                TabBarManager.shared.show()
            }
    }
}

// MARK: - View Extension
extension View {
    func hideTabBar() -> some View {
        self.modifier(HideTabBarModifier())
    }
} 
