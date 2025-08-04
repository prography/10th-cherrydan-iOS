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
            if banners.count > 1 {
                Text("\(index + 1)/\(banners.count)")
                    .font(.m6r)
                    .foregroundStyle(.gray0)
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
            
            HStack(alignment: .center, spacing: 12) {
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
                .frame(width: 48, height: 48)
                .cornerRadius(4)
                .clipped()
                
                VStack(alignment:.leading, spacing: 4){
                    Text(bannerData.title)
                        .font(.t4)
                        .foregroundStyle(.gray0)
                    
                    Text("지금 최고의 체험단에 신청해 보세요.")
                        .font(.t5)
                        .foregroundStyle(.gray0)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
            .padding(.leading, 12)
        }
        .background(.mPink2, in: RoundedRectangle(cornerRadius: 4))
    }
}
