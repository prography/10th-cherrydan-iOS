import SwiftUI
import WebKit

struct CampaignWebView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var router: HomeRouter
    let siteNameKr: String
    let campaignSiteUrl: String
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            HStack(alignment: .center) {
                Text(siteNameKr)
                    .font(.t3)
                    .foregroundStyle(.gray9)
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image("close")
                }
            }
            .frame(height: 52)
            .padding(.horizontal, 16)
            
            WebView(url: campaignSiteUrl)
                .ignoresSafeArea(.container, edges: .bottom)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    CampaignWebView(siteNameKr: "레뷰", campaignSiteUrl: "https://example.com")
        .environmentObject(HomeRouter())
} 
