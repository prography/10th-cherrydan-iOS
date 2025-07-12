import SwiftUI

extension View {
    func underline(_ color: Color = .gray5, width: CGFloat = 1) -> some View {
        modifier(UnderlineModifier(color: color, lineHeight: width))
    }
    
    func presentPopup(isPresented: Binding<Bool>, data: PopupType?) -> some View {
        modifier(PopupViewModifier(isPresented: isPresented, popupType: data))
    }
    
    func swipeBackDisabled(_ isDisabled: Bool) -> some View {
        modifier(SwipeBackDisabledViewModifier(isDisabled: isDisabled))
    }
}
