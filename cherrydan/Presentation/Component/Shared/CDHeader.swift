import SwiftUI

// MARK: - 타이틀이 있는 뒤로가기 네비게이션 바
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
        .padding(.horizontal, 16)
        .frame(height: 52)
    }
}
