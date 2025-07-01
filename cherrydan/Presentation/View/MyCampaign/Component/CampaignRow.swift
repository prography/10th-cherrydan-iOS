import SwiftUI

struct CampaignRow: View {
    let status: String
    let title: String
    let platform: SocialPlatform
    let reviewPlatform: ReviewPlatform
    let leftButtonTitle: String?
    let rightButtonTitle: String
    let isRightButtonPrimary: Bool
    let isChecked: Bool
    let onLeftButtonTap: (() -> Void)?
    let onRightButtonTap: (() -> Void)?
    
    init(
        status: String,
        title: String,
        platform: SocialPlatform,
        reviewPlatform: ReviewPlatform,
        leftButtonTitle: String? = nil,
        rightButtonTitle: String,
        isRightButtonPrimary: Bool = false,
        isChecked: Bool = false,
        onLeftButtonTap: (() -> Void)? = nil,
        onRightButtonTap: (() -> Void)? = nil
    ) {
        self.status = status
        self.title = title
        self.platform = platform
        self.reviewPlatform = reviewPlatform
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
                
                AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
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
                    Text(status)
                        .font(.m5b)
                        .foregroundStyle(.mPink3)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.m5b)
                            .foregroundStyle(.gray9)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Text("플랫폼: 1박스")
                            .foregroundStyle(.gray9)
                        
                        (
                            Text("신청 175/")
                                .foregroundStyle(.gray9)
                            +
                            Text("5명")
                                .foregroundStyle(.gray4)
                        )
                    }
                    .font(.m5r)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(platform.imageName)
                            
                            Text(platform.displayName)
                                .font(.m5r)
                                .foregroundStyle(.gray9)
                        }
                        
                        HStack(spacing: 4) {
                            Image(reviewPlatform.imageName)
                            
                            Text(reviewPlatform.displayName)
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
