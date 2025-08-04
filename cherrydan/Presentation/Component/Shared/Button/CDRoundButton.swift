import SwiftUI

struct CDRoundButton: View {
    let title: String
    let type: RoundButtonType
    let action: () -> Void
    
    init(_ title: String, type: RoundButtonType = .gray, action: @escaping () -> Void) {
        self.title = title
        self.type = type
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(type.font)
                .foregroundStyle(type.foregroundColor)
                .padding(.horizontal, type.horizontalPadding)
                .padding(.top, type.verticalPadding.top)
                .padding(.bottom, type.verticalPadding.bottom)
                .background(
                    type.backgroundColor,
                    in: RoundedRectangle(cornerRadius: type.cornerRadius)
                )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        CDRoundButton("Gray Button", type: .gray) { }
        CDRoundButton("Primary Button", type: .primary) { }
        CDRoundButton("White Button", type: .white) { }
    }
    .padding()
} 