import SwiftUI

struct CampaignSection: View {
    let campaigns = [
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "1"],
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "2"],
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "3"]
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(campaigns, id: \.self) { campaign in
                    CampaignBannerView(
                        order: campaign[2],
                        title: campaign[0],
                        description: campaign[1]
                    )
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
}

struct CampaignBannerView: View {
    let order: String
    let title: String
    let description: String
    
    var body: some View {
        ZStack {
            Text("\(order)/3")
                .font(.m6r)
                .foregroundStyle(.gray1)
                .padding(.horizontal,12)
                .frame(height: 24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                    .fill(.mPink3)
                )
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .bottomTrailing)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.t4)
                    .foregroundColor(.gray1)
                
                Text("지금 최고의 체험단에 신청해 보세요.")
                    .font(.t5)
                    .foregroundColor(.gray1)
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
