import SwiftUI

struct BannerWebView: View {
    let url: String
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: "")
                .padding(.horizontal, 16)
            
            WebView(url: url)
                .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}
