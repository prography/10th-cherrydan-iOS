import SwiftUI
import WebKit

struct CampaignWebView: View {
    let campaignSite: CampaignPlatformType
    let campaignSiteUrl: String
    @EnvironmentObject private var router: HomeRouter
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: campaignSite.rawValue)
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
