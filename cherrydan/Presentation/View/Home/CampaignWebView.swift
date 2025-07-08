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

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("WebView failed to load: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView finished loading")
        }
    }
}

#Preview {
    CampaignWebView(campaignSite: .revu, campaignSiteUrl: "https://example.com")
        .environmentObject(HomeRouter())
} 
