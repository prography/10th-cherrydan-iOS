import SwiftUI

struct CDHeaderWithLeftContent<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let onNotificationClick: (() -> Void)?
    let onSearchClick: () -> Void
    let leftContent: (() -> Content)
    
    init(
        onNotificationClick: (() -> Void)? = nil,
        onSearchClick: @escaping () -> Void,
        @ViewBuilder leftContent: @escaping () -> Content
    ) {
        self.onNotificationClick = onNotificationClick
        self.onSearchClick = onSearchClick
        self.leftContent = leftContent
    }
      
    var body: some View {
        HStack(alignment: .center) {
            leftContent()
            
            Spacer()
            
            if let onNotificationClick {
                Button(action: onNotificationClick) {
                    Image("notification")
                }
                .padding(.trailing, 4)
            }
            
            Button(action: onSearchClick) {
                Image("search_bg")
            }
            
        }
        .frame(height: 52)
    }
}
