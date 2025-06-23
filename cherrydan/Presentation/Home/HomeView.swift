import SwiftUI
import AuthenticationServices

struct HomeView: View {
    @EnvironmentObject var router: HomeRouter
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedTab = 0
    @State private var showCampaignPopup = false
    
    let buttonArr = ["인기 공고", "마감임박", "새로운 공고", "선정확률 높은", "관심 공고", "지역 맞춤"]
    
    let campaigns = [
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "1"],
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "2"],
        ["체험단 캠페인 여기 다 모았다!","지금 최고의 체험단에 신청해 보세요.", "3"]
    ]
    
    var body: some View {
        CHScreen {
            CDHeaderWithLeftContent() {
                HStack(spacing: 16) {
                    Button(action: {
                        //
                    }) {
                        HStack(alignment: .center) {
                            Text("카테고리")
                                .font(.t1)
                                .foregroundStyle(.gray9)
                            
                            Image("hamburger")
                        }
                    }
                }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
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
//        .presentPopup(
//            isPresented: $showCampaignPopup,
//            campaigns: CampaignRequest.sampleData,
//            onConfirm: { campaign in
//                print("선택된 캠페인: \(campaign.title)")
//                // 여기에 확인 버튼을 눌렀을 때의 액션을 추가할 수 있습니다.
//            }
//        )
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
    
    private var appleLoginSection: some View {
        VStack(spacing: 16) {
            Text("애플 로그인 테스트")
                .font(.t4)
                .foregroundStyle(.gray9)
            
            AppleSignInButton(
                onCompletion: { authorization in
                    Task {
                        await viewModel.performAppleLogin(authorization)
                    }
                },
                onError: { error in
                    viewModel.errorMessage = "애플 로그인 실패: \(error.localizedDescription)"
                }
            )
            
            if viewModel.isLoading {
                ProgressView("로그인 중...")
                    .font(.m5r)
                    .foregroundStyle(.gray5)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.m5r)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(Color.gray1)
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeView()
}
