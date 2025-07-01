import SwiftUI
import AuthenticationServices

struct HomeView: View {
    @EnvironmentObject var router: HomeRouter
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedCategory: CategoryType = .interestedRegion
    @State private var selectedTab: Int = 0
    @State private var showCampaignPopup = false
    
    let sortArr = ["인기순", "최신순", "마감임박순", "경쟁률 낮은순",]
    
    let campaigns = [
        ["체험단 캠페인 여기 다 모았다!", "지금 최고의 체험단에 신청해 보세요.", "1"],
        ["체험단 캠페인 여기 다 모았다!", "지금 최고의 체험단에 신청해 보세요.", "2"],
        ["체험단 캠페인 여기 다 모았다!", "지금 최고의 체험단에 신청해 보세요.", "3"]
    ]
    
    var body: some View {
        CHScreen(horizontalPadding: 0) {
            CDHeaderWithLeftContent() {
                HStack(spacing: 16) {
                    Button(action: {
                        //
                    }) {
                        Text("체리단")
                            .font(.t1)
                            .foregroundStyle(.gray9)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    CampaignBanner(campaigns: campaigns)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    
                    CDTabSection(selectedCategory: $selectedCategory)
                    
                    Divider()
                        .padding(.bottom, 16)
                    
                    HStack(spacing: 0) {
                        ForEach(0..<sortArr.count, id: \.self) { index in
                            tabItem(index)
                                .onTapGesture { selectedTab = index }
                        }
                    }
                    .padding(.horizontal, 6)
                    
                    Divider()
                    
                    campaignGridSection
                }
            }
        }
        .animation(.fastEaseInOut, value: selectedTab)
        //        .presentPopup(
        //            isPresented: $showCampaignPopup,
        //            campaigns: CampaignRequest.sampleData,
        //            onConfirm: { campaign in
        //                print("선택된 캠페인: \(campaign.title)")
        //                // 여기에 확인 버튼을 눌렀을 때의 액션을 추가할 수 있습니다.
        //            }
        //        )
    }
    
    private func tabItem(_ index:Int) -> some View {
        Text(sortArr[index])
            .font(selectedTab == index ? .m4b : .m4r)
            .foregroundStyle(selectedTab == index ? .mPink3 : .gray4)
            .padding(.horizontal, 10)
            .padding(.bottom, 8)
    }
    
    private var campaignGridSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 32) {
            ForEach(viewModel.campaigns) { campaign in
                CampaignCardView(campaign: campaign)
                    .frame(maxHeight: 290, alignment: .top)
            }
        }
        .padding(.top, 24)
    
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
