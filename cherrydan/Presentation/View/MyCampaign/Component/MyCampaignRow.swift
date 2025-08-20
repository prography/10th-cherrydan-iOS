import SwiftUI
import Kingfisher


struct MyCampaignRow: View {
    let myCampaign: MyCampaign
    let buttonConfigs: [ButtonConfig]
    
    init(
        myCampaign: MyCampaign,
        buttonConfigs: [ButtonConfig] = []
    ) {
        self.myCampaign = myCampaign
        self.buttonConfigs = buttonConfigs
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 4) {
                thumbnailSection
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(myCampaign.reviewerAnnouncementStatus)
                        .font(.m5b)
                        .foregroundStyle(.mPink3)
                    
                    campaignTextSection
                    platformListSection
                }
            }
            
            if !buttonConfigs.isEmpty {
                HStack(spacing: 8) {
                    ForEach(Array(buttonConfigs.enumerated()), id: \.offset) { index, config in
                        CDButton(
                            text: config.text,
                            type: config.type,
                            isDisabled: config.disabled,
                            action: config.onClick
                        )
                    }
                }
            }
        }
    }
    
    private var thumbnailSection: some View {
        KFImage(URL(string: myCampaign.imageUrl))
            .resizable()
            .onFailure { error in
                print("Image loading failed: \(error)")
            }
            .frame(width: 100, height: 100)
            .padding(.trailing, 8)
            .cornerRadius(4)
    }
    
    private var campaignTextSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(myCampaign.title)
                .font(.m5b)
                .foregroundStyle(.gray9)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Text(myCampaign.benefit)
                .font(.m5r)
                .foregroundStyle(.gray9)
                .lineLimit(1)
            
            (
                Text("신청 \(myCampaign.applicantCount)/")
                    .foregroundColor(.gray9)
                +
                Text("\(myCampaign.recruitCount)명")
                    .foregroundColor(.gray4)
            )
            .font(.m5r)
        }
    }
    
    private var platformListSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(myCampaign.snsPlatforms.prefix(2), id: \.self) { platform in
                HStack(spacing: 4) {
                    if !platform.imageName.isEmpty {
                        Image(platform.imageName)
                    }
                    
                    Text(platform.displayName)
                        .font(.m5r)
                        .foregroundStyle(.gray9)
                }
            }
            
            HStack(spacing: 4) {
                KFImage(URL(string: myCampaign.imageUrl))
                    .resizable()
                    .onFailure { error in
                        print("Image loading failed: \(error)")
                    }
                    .frame(width: 16, height: 16)
                    .cornerRadius(4)
                
                Text(myCampaign.campaignSite)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
            }
        }
    }
}
