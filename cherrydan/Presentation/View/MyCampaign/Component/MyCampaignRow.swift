import SwiftUI

struct MyCampaignRow: View {
    let myCampaign: MyCampaign
    let leftButtonTitle: String?
    let rightButtonTitle: String
    let isRightButtonPrimary: Bool
    let isChecked: Bool
    let onLeftButtonTap: (() -> Void)?
    let onRightButtonTap: (() -> Void)?
    
    init(
        myCampaign: MyCampaign,
        leftButtonTitle: String? = nil,
        rightButtonTitle: String,
        isRightButtonPrimary: Bool = false,
        isChecked: Bool = false,
        onLeftButtonTap: (() -> Void)? = nil,
        onRightButtonTap: (() -> Void)? = nil
    ) {
        self.myCampaign = myCampaign
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.isRightButtonPrimary = isRightButtonPrimary
        self.isChecked = isChecked
        self.onLeftButtonTap = onLeftButtonTap
        self.onRightButtonTap = onRightButtonTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 4) {
                Image("check_circle\(isChecked ? "_filled" : "_empty")")
                
                AsyncImage(url: URL(string: myCampaign.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(4)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                        )
                }
                .frame(width: 100, height: 100)
                .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(myCampaign.statusLabel)
                        .font(.m5b)
                        .foregroundStyle(.mPink3)
                    
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
                                .foregroundStyle(.gray9)
                            +
                            Text("\(myCampaign.recruitCount)명")
                                .foregroundStyle(.gray4)
                        )
                        .font(.m5r)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(myCampaign.snsPlatforms.prefix(2), id: \.self) { platform in
                            HStack(spacing: 4) {
                                Image(platform.imageName)
                                
                                Text(platform.rawValue)
                                    .font(.m5r)
                                    .foregroundStyle(.gray9)
                            }
                        }
                        
                        HStack(spacing: 4) {
                            AsyncImage(url: URL(string: myCampaign.campaignPlatformImageUrl)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.gray2)
                            }
                            .frame(width: 16, height: 16)
                            .cornerRadius(4)
                            
                            Text(myCampaign.campaignSite.rawValue)
                                .font(.m5r)
                                .foregroundStyle(.gray9)
                        }
                    }
                }
                
                Spacer()
            }
            
            
            HStack(spacing: 8) {
                Spacer()
                
                if let leftButtonTitle {
                    mainButton(leftButtonTitle, isMinor: true){
                        onLeftButtonTap?()
                    }
                }
                
                mainButton(rightButtonTitle){
                    onRightButtonTap?()
                }
            }
        }
        .background(.white)
    }
    
    private func mainButton(_ title: String, isMinor: Bool = false, _ action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.m5r)
                .foregroundStyle(isMinor ? .gray5 : .gray0)
                .padding(.vertical, 14)
        }
        .frame(maxWidth: .infinity)
        .background(isMinor ? .gray2 : .mPink2, in: RoundedRectangle(cornerRadius: 2))
    }
}
