import SwiftUI

// MARK: - 타이틀이 있는 뒤로가기 네비게이션 바
struct CDHeaderWithLeftContent<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    
    let leftContent: (() -> Content)
    let searchAction: (() -> Void)?
    
    init(@ViewBuilder leftContent: @escaping () -> Content, searchAction: (() -> Void)? = nil) {
        self.leftContent = leftContent
        self.searchAction = searchAction
    }
      
    var body: some View {
        HStack(alignment: .center) {
            leftContent()
            
            Spacer()
            
            HStack(spacing: 4) {
                Button(action: {}) {
                    Image("notification")
                }
                
                Button(action: {
                    searchAction?()
                }) {
                    Image("search_bg")
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
    }
}
