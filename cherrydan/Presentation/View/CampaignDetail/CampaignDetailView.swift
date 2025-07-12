import SwiftUI
import WebKit

struct CampaignWebView: View {
    @Environment(\.dismiss) var dismiss
    let campaignSite: CampaignPlatformType
    let campaignSiteUrl: String
    @EnvironmentObject private var router: HomeRouter
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            HStack(alignment: .center) {
                Text(campaignSite.rawValue)
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
    CampaignWebView(campaignSite: .revu, campaignSiteUrl: "https://example.com")
        .environmentObject(HomeRouter())
} 
