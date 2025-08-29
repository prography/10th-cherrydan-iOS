import SwiftUI

struct CampaignBanner: View {
    let banners: [NoticeBoardBanner]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(banners.enumerated()), id: \.offset) { index, bannerData in
                    NavigationLink(destination: BannerWebView(url: bannerData.targetUrl)) {
                        campainBannerItem(bannerData, index: index)
                    }
                    .padding(.horizontal, 16)
                    .frame(width: UIScreen.main.bounds.width)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.8)
                            .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
    
    
    @ViewBuilder
    private func campainBannerItem(_ bannerData: NoticeBoardBanner, index: Int) -> some View {
        let backgroundColor = CampaignColor(rawValue: bannerData.backgroundColor)?.backgroundColor ?? .mPink2
        
        ZStack(alignment: .bottomTrailing) {
            if banners.count > 1 {
                Text("\(index + 1)/\(banners.count)")
                    .font(.m6r)
                    .foregroundStyle(backgroundColor == .mPink2 ? .gray0 : .gray5)
                    .padding(.horizontal, 12)
                    .frame(height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(backgroundColor == .mPink2 ? .mPink3 : .pBeige)
                    )
                    .padding(12)
            }
            
            VStack(alignment:.leading, spacing: 4){
                Text(bannerData.title)
                    .font(.t4)
                    .foregroundStyle(backgroundColor == .mPink2 ? .gray0 : .gray9)
                
                Text(bannerData.subTitle)
                    .font(.t5)
                    .foregroundStyle(backgroundColor == .mPink2 ? .gray0 : .gray5)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .padding(.leading, 12)
        }
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 4))
    }
}


enum CampaignColor: String {
    case Mpink2
    case PBlue
    
    var backgroundColor: Color {
        switch self {
        case .PBlue:
            return .pBlue
        case .Mpink2:
            return .mPink2
        }
    }
}
