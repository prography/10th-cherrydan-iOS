import SwiftUI

struct CampaignBanner: View {
    let banners: [NoticeBoardBanner]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(Array(banners.enumerated()), id: \.offset) { index, bannerData in
                    campainBannerItem(bannerData, index: index)
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
    
    private func campainBannerItem(_ bannerData: NoticeBoardBanner, index: Int) -> some View {
        ZStack {
            AsyncImage(url: URL(string: bannerData.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
            }
            .frame(height: 120)
            .clipped()
            
            // 페이지 인디케이터
            if banners.count > 1 {
                Text("\(index + 1)/\(banners.count)")
                    .font(.m6r)
                    .foregroundStyle(.gray1)
                    .padding(.horizontal, 12)
                    .frame(height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                        .fill(.mPink3)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.bottom, 12)
                    .padding(.trailing, 12)
            }
            
            // 배너 텍스트 컨텐츠
            VStack(alignment: .leading, spacing: 4) {
                Text(bannerData.title)
                    .font(.t4)
                    .foregroundStyle(.gray1)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.leading, 12)
            .padding(.top, 12)
        }
        .background(.mPink2, in: RoundedRectangle(cornerRadius: 4))
    }
}
