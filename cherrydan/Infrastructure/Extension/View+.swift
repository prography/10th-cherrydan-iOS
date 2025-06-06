import SwiftUI

struct UnderlineModifier: ViewModifier {
    let color: Color
    let lineHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .fill(color)
                    .frame(height: lineHeight)
                    .offset(y: 0),
                alignment: .bottom
            )
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

extension View {
    @ViewBuilder
    func conditionalHideTabBar(shouldHide: Bool) -> some View {
        if shouldHide {
            self.hideTabBar()
        } else {
            self
        }
    }
    
    func underline(_ color: Color = .gray5, width: CGFloat = 1) -> some View {
        modifier(UnderlineModifier(color: color, lineHeight: width))
    }
    
    func hideTabBar() -> some View {
        self.modifier(HideTabBarModifier())
    }
}
