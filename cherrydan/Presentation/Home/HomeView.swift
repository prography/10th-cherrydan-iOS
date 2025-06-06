import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedTab = 0
    
    let buttonArr = ["인기 공고", "마감임박", "새로운 공고", "선정확률 높은", "관심 공고", "지역 맞춤"]
    
    let campaigns = [
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "1"],
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "2"],
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "3"]
    ]
    
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            VStack(spacing: 0) {
                CDHeaderWithLeftContent() {
                    Button(action: {
                        viewModel.navigateTo(.category)
                    }) {
                        HStack(alignment: .center) {
                            Text("카테고리")
                                .font(.t1)
                                .foregroundStyle(.gray9)
                            
                            Image("hamburger")
                        }
                    }
                }
                
                
                ScrollView {
                    VStack(spacing: 20) {
                        CampaignBanner(campaigns: campaigns)
                        
                        CDTabSection(
                            selectedTab: $selectedTab,
                            data: buttonArr
                        )
                        
                        campaignGridSection
                    }
                }
            }
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .category:
                    CategoryView()
                case .search:
                    SearchView()
                }
            }
        }
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
}

#Preview {
    HomeView()
}
