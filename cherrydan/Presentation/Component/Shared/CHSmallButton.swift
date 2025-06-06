import SwiftUI

struct CHSmallButton: View {
    let title: String
    let isMinor: Bool
    let action: () -> Void
    
    init(_ title: String, isMinor: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isMinor = isMinor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.m5r)
                .foregroundStyle(isMinor ? .gray5 : .white)
                .padding(.horizontal, 12)
                .padding(.top, 6)
                .padding(.bottom, 8)
                .background(
                    isMinor ? .gray2 : .mPink2,
                    in: RoundedRectangle(cornerRadius: 16)
                )
        }
    }
}
