import SwiftUI

struct MyCampaignView: View {
    @EnvironmentObject private var router: MyCampaignRouter
    @StateObject private var viewModel = MyCampaignViewModel()
//    @State private var selectedTab = 1 // 신청 탭이 기본 선택
    
    
    private let tabData = [
        ("찜한 공고", 2),
//        ("신청", 3),
//        ("선정", 2),
//        ("등록", 1),
//        ("종료", 1)
    ]
    
    var body: some View {
        CDScreen(
            horizontalPadding: 0,
            isLoading: viewModel.isLoading || viewModel.isLoadingMore && !viewModel.isShowingClosedCampaigns
        ) {
            CDHeaderWithRightContent(title: "내 체험단"){}
                .padding(.horizontal, 16)
            
            //            tabSection
            //                .padding(.horizontal, 16)
            Text("찜한 공고")
                .font(.m3b)
                .foregroundStyle(.mPink3)
                .padding(16)
            
            if !viewModel.isShowingClosedCampaigns {
                openSection
            } else {
                closedCampaignListSection
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.mediumSpring, value: viewModel.isShowingClosedCampaigns)
    }
    
    private var openSectionPlaceholder: some View {
        VStack(spacing: 12) {
            Text("찜한 공고 중 신청 가능한 공고가 없어요")
                .font(.m4r)
                .foregroundStyle(.gray5)
                .padding(.vertical, 120)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    private var openSection: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.likedCampaigns.isEmpty {
                openSectionPlaceholder
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(Array(zip(viewModel.likedCampaigns.indices, viewModel.likedCampaigns)), id: \.1.id) { index, campaign in
                        MyCampaignRow(
                            myCampaign: campaign,
                            buttonConfigs: [
                                ButtonConfig(
                                    text: "찜 취소하기",
                                    type: .smallGray,
                                    onClick: {
                                        PopupManager.shared.show(.cancelZzim(onClick: {
                                            viewModel.cancelBookmark(for: campaign.campaignId)
                                        }))
                                    }
                                ),
                                ButtonConfig(
                                    text: "공고 보기",
                                    type: .smallPrimary,
                                    onClick: {
                                        router.push(to: .campaignWeb(
                                            siteNameKr: campaign.campaignSite,
                                            campaignSiteUrl: campaign.campaignDetailUrl
                                        ))
                                    }
                                )
                            ]
                        )
                        .onAppear {
                            if !viewModel.isShowingClosedCampaigns,
                               index == viewModel.likedCampaigns.count - 10,
                               viewModel.hasMoreOpenPages,
                               !viewModel.isLoadingMore {
                                viewModel.loadNextPage()
                            }
                        }
                        Divider()
                    }
                }
                .padding(.horizontal, 16)
            }
            closedSectionButton
        }
        .transition(.move(edge: .leading))
    }
    
    private var closedSectionButton: some View {
        Button(action: {
            viewModel.isShowingClosedCampaigns = true
            viewModel.handleToggleClosed(true)
        }) {
            HStack{
                Text("신청 마감된 공고")
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .font(.m3b)
                    .foregroundStyle(.gray5)
                
                Image("chevron_right")
            }
            .padding(.horizontal, 16)
            .frame(height: 80, alignment: .center)
            .background(.gray1)
        }
    }
    
    private var closedCampaignListSection: some View {
        VStack(spacing: 0) {
            Button(action: {
                    viewModel.isShowingClosedCampaigns = false
                    viewModel.handleToggleClosed(false)
            }) {
                HStack(spacing: 0) {
                    Image("chevron_left")
                    Text("신청 마감된 공고")
                        .font(.m3b)
                        .foregroundStyle(.gray9)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            
            if viewModel.likedClosedCampaigns.isEmpty {
                closedSectionPlaceholder
            } else {
                closedSection
            }
        }
        .background(.gray1)
    }
    
    private var closedSectionPlaceholder: some View {
            Text("마감된 공고가 없습니다")
                .font(.m4r)
                .foregroundStyle(.gray5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    private var closedSection: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(Array(zip(viewModel.likedClosedCampaigns.indices, viewModel.likedClosedCampaigns)), id: \.1.id) { index, campaign in
                    MyCampaignRow(
                        myCampaign: campaign,
                        buttonConfigs: [
                            ButtonConfig(
                                text: "찜 취소하기",
                                type: .smallGray,
                                onClick: {
                                    PopupManager.shared.show(.cancelZzim(onClick: {
                                        viewModel.cancelBookmark(for: campaign.campaignId)
                                    }))
                                }
                            ),
                            ButtonConfig(
                                text: "공고 확인하기",
                                type: .smallWhite,
                                onClick: {
                                    router.push(to: .campaignWeb(
                                        siteNameKr: campaign.campaignSite,
                                        campaignSiteUrl: campaign.campaignDetailUrl
                                    ))
                                }
                            )
                        ]
                    )
                    .onAppear {
                        if viewModel.isShowingClosedCampaigns,
                           index == viewModel.likedClosedCampaigns.count - 10,
                           viewModel.hasMoreClosedPages,
                           !viewModel.isLoadingMore {
                            viewModel.loadNextPage()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if viewModel.isLoadingMore && viewModel.isShowingClosedCampaigns {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
    
//    private var tabSection: some View {
//        VStack(spacing: 0) {
//            HStack(spacing: 24) {
//                ForEach(0..<tabData.count, id: \.self) { index in
//                    tabItem(index)
//                }
//            }
//            
//            Divider()
//                .background(.gray2)
//        }
//    }
//    private func tabItem(_ index: Int) -> some View {
//        Button(action: {
//            selectedTab = index
//        }) {
//            VStack(spacing: 8) {
//                HStack(spacing: 4) {
//                    Text(tabData[index].0)
//                        .font(.m4b)
//                        .foregroundStyle(selectedTab == index ? .mPink3 : .gray5)
//                    
//                    Text("\(tabData[index].1)")
//                        .font(.m4b)
//                        .foregroundStyle(selectedTab == index ? .mPink3 : .gray5)
//                }
//                
//                Rectangle()
//                    .fill(selectedTab == index ? .mPink3 : .clear)
//                    .frame(height: 2)
//            }
//        }
//    }
}

#Preview {
    MyCampaignView()
} 
