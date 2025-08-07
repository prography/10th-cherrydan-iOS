import SwiftUI

struct CDScreen<Content: View>: View {
    let content: Content
    let isAlignCenter: Bool
    let horizontalPadding: CGFloat
    let isLoading: Bool
    
    init(
        horizontalPadding: CGFloat = 16,
        isAlignCenter: Bool = false,
        isLoading: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.horizontalPadding = horizontalPadding
        self.isAlignCenter = isAlignCenter
        self.isLoading = isLoading
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: isAlignCenter ? .center : .leading, spacing: 0) {
            content
        }
        .padding(.horizontal, horizontalPadding)
        .background(.gray0)
        .navigationBarBackButtonHidden(true)
        .overlay {
            Group {
                if isLoading {
                    CDLoadingIndicator()
                }
            }
        }
    }
}
