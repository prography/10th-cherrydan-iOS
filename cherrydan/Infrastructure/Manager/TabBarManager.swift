import SwiftUI
import Combine

@MainActor
final class TabBarManager: ObservableObject {
    static let shared = TabBarManager()
    
    @Published var isHidden = false
    
    private init() {}
    
    func hide() {
        guard isHidden == false else { return }
        isHidden = true
    }
    
    func show() {
        guard isHidden == true else { return }
        withAnimation(.fastSpring) {
            isHidden = false
        }
    }
}
