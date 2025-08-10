import SwiftUI

struct CDBackHeaderWithTitle<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String?
    let onPressBack: (() -> Void)?
    let rightContent: (() -> Content)?
    
    init(
        title: String,
        onPressBack: (() -> Void)?,
        @ViewBuilder rightContent: @escaping () -> Content
    ) {
        self.title = title
        self.onPressBack = onPressBack
        self.rightContent = rightContent
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Button(action: {
                if let onPressBack {
                    onPressBack()
                } else {
                    dismiss()
                }
            }) {
                Image("chevron_left")
                
                if let title {
                    Text(title)
                        .font(.t3)
                        .foregroundStyle(.gray9)
                }
            }
            
            if let rightContent {
                rightContent()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(height: 40)
        .background(.gray0)
    }
}

// MARK: - BackNavWithTitle 확장 (rightContent 없는 경우)
extension CDBackHeaderWithTitle where Content == EmptyView {
    init(title: String,_ onPressBack: (() -> Void)? = nil) {
        self.title = title
        self.onPressBack = onPressBack
        self.rightContent = nil
    }
}

extension CDBackHeaderWithTitle {
    init(
        title: String,
         @ViewBuilder rightContent: @escaping () -> Content
    ) {
        self.title = title
        self.onPressBack = nil
        self.rightContent = rightContent
    }
}
