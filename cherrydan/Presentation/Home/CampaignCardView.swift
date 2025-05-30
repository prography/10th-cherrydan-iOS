import SwiftUI

struct CampaignCardView: View {
    let image: String
    let remainingDays: Int
    let title: String
    let subtitle: String
    let applicantCount: Int
    let totalApplicants: Int
    let socialPlatform: SocialPlatform
    let reviewPlatform: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: image)) { image in
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
                
                Text("\(reviewPlatform)")
                    .font(.m6r)
                    .foregroundColor(.gray0)
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
            
            Text("\(remainingDays)일 남음")
                .font(.m5b)
                .foregroundStyle(.mPink3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.m5b)
                    .lineLimit(1)
                
                Text(subtitle)
                    .font(.m5r)
                    .foregroundColor(.gray9)
                
                HStack(spacing: 0) {
                    Text("신청 \(applicantCount)/")
                        .font(.m5r)
                        .foregroundColor(.gray9)
                    
                    Text("\(totalApplicants)명")
                        .font(.m5r)
                        .foregroundColor(.gray4)
                }
            }
            
            HStack(spacing: 4) {
                Image(socialPlatform.imageName)
                
                Text(socialPlatform.displayName)
                    .font(.m5r)
                    .foregroundColor(.gray9)
            }
        }
    }
}
