import SwiftUI

struct CampaignCardView: View {
    let campaign: Campaign
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            thumbnail
            textSection
        }
        .frame(maxHeight: 320, alignment: .top)
    }
    
    private var thumbnail: some View {
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
            .frame(width: 168, height: 168)
            .cornerRadius(4)
            .clipped()
            
            Text(campaign.campaignSite.rawValue)
                .font(.m6r)
                .foregroundStyle(.pBlue)
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
    }
    
    private var textSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(campaign.reviewerAnnouncementStatus)
                .font(.m5b)
                .foregroundStyle(.mPink3)
                .lineLimit(1)
            
            VStack(alignment: .leading, spacing: 4){
                Text(campaign.title)
                    .font(.m5b)
                    .foregroundStyle(.gray9)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(campaign.benefit)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            (
                Text("신청 \(campaign.applicantCount)/")
                    .foregroundColor(.gray9)
                +
                Text("\(campaign.recruitCount)명")
                    .foregroundColor(.gray4)
            )
            .font(.m5r)
            
            platformStatus
        }
    }
    
    private var platformStatus: some View {
        HStack(spacing: 8) {
            ForEach(Array(campaign.snsPlatforms.prefix(2)), id: \.self) { sns in
                HStack(spacing: 4) {
                    Image(sns.imageName)
                    
                    Text(sns.rawValue)
                        .font(.m6r)
                        .foregroundStyle(.gray9)
                }
            }
            
            if campaign.snsPlatforms.count > 2 {
                Text("+\(campaign.snsPlatforms.count - 2)")
                    .font(.m6r)
                    .foregroundStyle(.gray5)
            }
            
            Spacer()
        }
    }
}
