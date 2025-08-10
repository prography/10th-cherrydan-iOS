import SwiftUI

struct PopupViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State private var isAnimating: Bool = false
    
    let popupType: PopupType?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented, let popupType {
                    ZStack {
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                            .opacity(isAnimating ? 0.3 : 0.0)
                            .onTapGesture {
                                if popupType.config.isDismissNeeded { dismissPopup() }
                            }
                            .animation(.spring(duration: 0.1), value: isAnimating)
                        
                        CDPopup(
                            hidePopup: dismissPopup,
                            type: popupType
                        )
                        .opacity(isAnimating ? 1 : 0)
                        .offset(y: isAnimating ? 0 : -80)
                        .animation(.spring(duration: 0.3), value: isAnimating)
                    }
                }
            }
            .onChange(of: isPresented) { _, newValue in
                isAnimating = newValue
            }
    }
    
    private func dismissPopup() {
        isPresented = false
        isAnimating = false
    }
}
