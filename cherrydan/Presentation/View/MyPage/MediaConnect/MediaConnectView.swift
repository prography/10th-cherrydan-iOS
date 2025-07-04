import SwiftUI

struct MediaConnectView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var naverBlogConnected = true
    @State private var instagramConnected = true
    @State private var youtubeConnected = false
    @State private var tiktokConnected = false
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: "미디어 연결")
                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 24) {
                    mediaItemSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 120)
            }
            
            Spacer()
        }
    }
    
    private var mediaItemSection: some View {
        VStack(spacing: 24) {
            mediaItem(
                platformName: .naverBlog,
                isConnected: naverBlogConnected,
                url: "https://www.naver.com",
                onButtonTap: {
                    naverBlogConnected.toggle()
                }
            )
        
            mediaItem(
                platformName: .instagram,
                isConnected: instagramConnected,
                url: "https://www.instagram.com",
                onButtonTap: {
                    instagramConnected.toggle()
                }
            )
            
            mediaItem(
                platformName: .youtube,
                isConnected: youtubeConnected,
                url: nil,
                onButtonTap: {
                    youtubeConnected.toggle()
                }
            )
            
            mediaItem(
                platformName: .naverBlog,
                isConnected: tiktokConnected,
                url: nil,
                onButtonTap: {
                    tiktokConnected.toggle()
                }
            )
        }
    }
    
    private func mediaItem(
        platformName: SocialPlatformType,
        isConnected: Bool,
        url: String?,
        onButtonTap: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(platformName.imageName)
                
                Text(platformName.displayName)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
            }
            
            VStack {
                if let url {
                    Text(url)
                        .font(.m2r)
                        .foregroundStyle(.gray9)
                } else {
                    Text("연결해 주세요!")
                        .font(.m2r)
                        .foregroundStyle(.gray4)
                }
            }
            .frame(height: 44, alignment: .center)
            
            CDSmallButton(
                isConnected ? "연결 해제" : "연결하기",
                isMinor: isConnected
            ) {
                onButtonTap()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.bottom, 12)
            
            Divider()
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    MediaConnectView()
} 
