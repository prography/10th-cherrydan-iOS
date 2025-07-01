import SwiftUI

struct NoticeDetailView: View {
    let noticeId: String
    
    var body: some View {
        VStack(spacing: 40) {
            Text("NoticeDetailView")
        }
    }
}

#Preview {
    NoticeDetailView(noticeId: "Asdf")
}
