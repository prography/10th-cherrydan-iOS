import SwiftUI

struct HideTabBarModifier: ViewModifier {
    let shouldHide: Bool
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if shouldHide {
                    TabBarManager.shared.hide()
                } else {
                    TabBarManager.shared.show()
                }
            }
            .onDisappear {
                TabBarManager.shared.show()
            }
    }
}
