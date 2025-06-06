import SwiftUI

struct CDTextField<T>: View where T: Hashable {
    @Binding var text: T
    
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var onSubmit: (() -> Void)?
    var textColor: Color = .gray9
    var placeholderColor: Color = .gray4
    var backgroundColor: Color = .gray1
    var borderColor: Color = .clear
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField("", text: Binding(
                    get: { String(describing: text) },
                    set: { if let value = $0 as? T { text = value } }
                ), prompt: Text(placeholder)
                    .font(.m5r)
                    .foregroundColor(placeholderColor))
            } else {
                TextField("", text: Binding(
                    get: { String(describing: text) },
                    set: { if let value = $0 as? T { text = value } }
                ), prompt: Text(placeholder)
                    .font(.m5r)
                    .foregroundColor(placeholderColor)
                )
            }
        }
        .foregroundStyle(textColor)
        .padding(.horizontal, 8)
        .frame(height: 40)
        
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(borderColor, lineWidth: 1)
        )
        .autocapitalization(.none)
        .keyboardType(keyboardType)
        .onSubmit {
            onSubmit?()
        }
    }
}
