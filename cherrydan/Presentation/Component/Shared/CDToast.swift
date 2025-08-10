import SwiftUI
import Foundation

struct CDToast: View {
    let toastType: ToastType
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 20, height: 20)
            
            Text(toastType.text)
                .font(.m3r)
                .foregroundStyle(.gray9)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let button = toastType.button {
                Button(action: button.onClick) {
                    Text(button.text)
                        .font(.m3r)
                        .foregroundStyle(.mPink3)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.pBlue)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
    }
    
    private var iconName: String {
        switch toastType {
        case .error, .errorWithTaskName, .errorWithMessage:
            return "exclamationmark.triangle.fill"
        case .success:
            return "checkmark.circle.fill"
        }
    }
    
    private var iconColor: Color {
        switch toastType {
        case .error, .errorWithTaskName, .errorWithMessage:
            return .red
        case .success:
            return .green
        }
    }
}
