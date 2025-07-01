import SwiftUI

struct CDHeaderWithLeftContent<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let leftContent: (() -> Content)
    
    init(@ViewBuilder leftContent: @escaping () -> Content) {
        self.leftContent = leftContent
    }
      
    var body: some View {
        HStack(alignment: .center) {
            leftContent()
            
            Spacer()
            
            HStack(spacing: 4) {
                Button(action: {}) {
                    Image("notification")
                }
                
                Button(action: {}) {
                    Image("search_bg")
                }
            }
        }
        .frame(height: 52)
    }
}
