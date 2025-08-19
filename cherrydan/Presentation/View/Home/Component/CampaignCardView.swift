import SwiftUI
import Kingfisher

struct CampaignCardView: View {
    let campaign: Campaign
    let onToggle: () -> Void
    @State private var didFailToLoadThumbnailImage: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            thumbnail
            textSection
        }
        .frame(maxHeight: 320, alignment: .top)
    }
    
    private var thumbnail: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if didFailToLoadThumbnailImage || URL(string: campaign.imageUrl) == nil {
                        Image("placeholder")
                            .resizable()
                    } else {
                        KFImage(URL(string: campaign.imageUrl))
                            .resizable()
                            .placeholder {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(
                                        ProgressView()
                                    )
                            }
                            .onFailure { error in
                                print("Image loading failed: \(error)")
                                didFailToLoadThumbnailImage = true
                            }
                            .onSuccess { _ in
                                didFailToLoadThumbnailImage = false
                            }
                    }
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: 168)
                .overlay(
                    VStack {
                        Spacer()
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.gray9.opacity(0.0),
                                Color.gray9.opacity(0.7)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 44)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                )
                .cornerRadius(4)
                .onChange(of: campaign.imageUrl) { _, _ in
                    didFailToLoadThumbnailImage = false
                }
                
                Text(campaign.campaignSite.siteNameKr)
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                Button(action: {
                    onToggle()
                }) {
                    Image("like\(campaign.isBookmarked ? "_filled" : "")")
                        .padding(4)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 168)
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
        VStack(alignment: .leading, spacing: 4) {
            ForEach(Array(campaign.snsPlatforms.prefix(2)), id: \.self) { sns in
                HStack(spacing: 4) {
                    if !sns.imageName.isEmpty {
                        Image(sns.imageName)
                    }
                    
                    Text(sns.displayName)
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
