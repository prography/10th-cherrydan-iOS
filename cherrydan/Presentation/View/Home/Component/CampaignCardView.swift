import SwiftUI

struct CampaignCardView: View {
    let campaign: Campaign
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: campaign.imageUrl)) { image in
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
                .frame(height: 168)
                .cornerRadius(4)
                
                Text(campaign.benefit)
                    .font(.m6r)
                    .foregroundStyle(.gray0)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.gray5)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 4,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 4,
                            topTrailingRadius: 0
                        )
                    )
            }
            
            HStack {
                Text(campaign.campaignType.displayName)
                    .font(.m5b)
                    .foregroundStyle(.mPink3)
                
                Spacer()
                
                Text(String(format: "%.1f:1", campaign.competitionRate))
                    .font(.m5b)
                    .foregroundStyle(.mPink3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(campaign.title)
                    .font(.m5b)
                    .lineLimit(1)
                
                Text(campaign.benefit)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
                    .lineLimit(2)
                
                Text(campaign.address)
                    .font(.m5r)
                    .foregroundStyle(.gray4)
                
                HStack(spacing: 0) {
                    Text("신청 \(campaign.applicantCount)/")
                        .font(.m5r)
                        .foregroundStyle(.gray9)
                    
                    Text("\(campaign.recruitCount)명")
                        .font(.m5r)
                        .foregroundStyle(.gray4)
                }
            }
            
            HStack(spacing: 4) {
                ForEach(campaign.platforms.prefix(2), id: \.self) { platform in
                    if let socialPlatform = SocialPlatform(rawValue: platform) {
                        Image(socialPlatform.imageName)
                    }
                }
                
                if campaign.platforms.count > 2 {
                    Text("+\(campaign.platforms.count - 2)")
                        .font(.m5r)
                        .foregroundStyle(.gray4)
                }
            }
        }
    }
}
