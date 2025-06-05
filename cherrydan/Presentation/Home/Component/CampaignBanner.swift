import SwiftUI

struct CampaignBanner: View {
    let campaigns: [[String]]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(campaigns, id: \.self) { campaign in
                    campainBannerItem(campaign)
                        .padding(16)
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
    
    private func campainBannerItem(_ campaign:[String])-> some View {
        ZStack {
            Text("\(campaign[2])/3")
                .font(.m6r)
                .foregroundStyle(.gray1)
                .padding(.horizontal,12)
                .frame(height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                    .fill(.mPink3)
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(campaign[0])
                    .font(.t4)
                    .foregroundStyle(.gray1)
                
                Text(campaign[1])
                    .font(.t5)
                    .foregroundStyle(.gray1)
            }
            .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.mPink3)
        )
    }
}
