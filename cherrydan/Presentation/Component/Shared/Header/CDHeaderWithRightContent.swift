import SwiftUI

struct CDHeaderWithRightContent<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let rightContent: (() -> Content)
    
    init(title: String, @ViewBuilder rightContent: @escaping () -> Content) {
        self.title = title
        self.rightContent = rightContent
    }
      
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(.t1)
                .foregroundStyle(.gray9)
            
            Spacer()
            
            rightContent()
        }
        .frame(height: 52)
    }
}
