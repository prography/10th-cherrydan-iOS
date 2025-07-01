import SwiftUI

struct CHButton: View {
    let text: String
    let onConfirm: () -> Void
    
    var body: some View {
        Button(action: onConfirm) {
            Text(text)
                .font(.m3r)
                .foregroundStyle(.gray0)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.mPink3, in: RoundedRectangle(cornerRadius: 4))
        }
    }
}
