import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0
    let buttonArr = ["인기 공고", "마감임박", "새로운 공고", "선정확률 높은", "관심 공고", "지역 맞춤"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                    .padding(.horizontal, 16)
                
                CampaignSection()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0..<buttonArr.count, id: \.self) { index in
                            categorySection(index)
                                .onTapGesture { selectedTab = index }
                        }
                        .padding(.horizontal, 8)
                    }
                    .padding(.horizontal, 8)
                    
                }
                
                campaignGridSection
            }
        }
        .animation(.spring, value: selectedTab)
    }
    
    private var campaignGridSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 32) {
            ForEach(CampaignData.dummy) { campaign in
                CampaignCardView(
                    image: campaign.image,
                    remainingDays: campaign.remainingDays,
                    title: campaign.title,
                    subtitle: campaign.subtitle,
                    applicantCount: campaign.applicantCount,
                    totalApplicants: campaign.totalApplicants,
                    socialPlatform: campaign.socialPlatform,
                    reviewPlatform: campaign.reviewPlatform
                )
            }
        }
        .padding(.horizontal)
    }
    
    private func categorySection(_ index:Int) -> some View {
        VStack(spacing: 8){
            Text(buttonArr[index])
                .font(.m3b)
                .foregroundColor(selectedTab == index ? .mPink3 : .gray4)
                .padding(.horizontal, 4)
            
            Rectangle()
                .fill(index == selectedTab ? .mPink3 : .clear)
                .frame(height: 2)
        }
    }
}

private var header: some View {
    HStack(alignment: .center) {
        Text("카테고리")
            .font(.t1)
        Image("hamburger")
        
        Spacer()
        
        HStack(spacing: 4) {
            Button(action: {}) {
                Image("alarm")
            }
            
            Button(action: {}) {
                Image("search")
            }
        }
    }
    .padding(.top, 8)
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} 
