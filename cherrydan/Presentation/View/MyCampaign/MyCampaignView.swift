import SwiftUI

struct MyCampaignView: View {
    @EnvironmentObject private var router: MyCampaignRouter
    @StateObject private var viewModel = MyCampaignViewModel()
    
    var body: some View {
        CDScreen(
            horizontalPadding: 0,
            isLoading: viewModel.isLoading && !viewModel.isShowingClosedCampaigns
        ) {
            CDHeaderWithRightContent(title: "내 체험단"){
                if !viewModel.isDeleteMode {
                    Button(action: {
                        viewModel.isDeleteMode = true
                    }){
                        Image("trash")
                    }
                }
            }
            .padding(.horizontal, 16)
            
            tabSection
                .padding(.top, 24)
            
            campaignListSection
        }
        .animation(.mediumSpring, value: viewModel.isShowingClosedCampaigns)
    }
    
    @ViewBuilder
    private var campaignListSection: some View {
        switch viewModel.selectedCampaignStatus {
        case .apply:
            if !viewModel.isShowingClosedCampaigns {
                openSection
            } else {
                closedCampaignListSection
                    .transition(.move(edge: .trailing))
            }
        default:
            openSection
        }
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
            if viewModel.mainCampaigns.isEmpty {
                openSectionPlaceholder
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(Array(zip(viewModel.mainCampaigns.indices, viewModel.mainCampaigns)), id: \.1.id) { index, campaign in
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
                                            campaignSiteUrl: campaign.detailUrl
                                        ))
                                    }
                                )
                            ]
                        )
                        .onAppear {
                            if !viewModel.isShowingClosedCampaigns,
                               index == viewModel.mainCampaigns.count - 10,
                               viewModel.hasMoreOpenPages,
                               !viewModel.isLoading {
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
            
            if viewModel.closedCampaigns.isEmpty {
                closedSectionPlaceholder
            }
            closedSection
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
                ForEach(Array(zip(viewModel.closedCampaigns.indices, viewModel.closedCampaigns)), id: \.1.id) { index, campaign in
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
                                        campaignSiteUrl: campaign.detailUrl
                                    ))
                                }
                            )
                        ]
                    )
                    .onAppear {
                        if viewModel.isShowingClosedCampaigns,
                           index == viewModel.closedCampaigns.count - 10,
                           viewModel.hasMoreClosedPages,
                           !viewModel.isLoading {
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
            if viewModel.isLoading && viewModel.isShowingClosedCampaigns {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
    
    private var tabSection: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(CampaignStatusType.allCases, id: \.self) { status in
                        tabItem(status)
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Divider()
        }
    }
    
    @ViewBuilder
    private func tabItem(_ status: CampaignStatusType) -> some View {
        let isSelected = status == viewModel.selectedCampaignStatus
        Button(action: {
            viewModel.selectedCampaignStatus = status
        }) {
            
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Text(status.displayText)
                        .font(.m4b)
                        .foregroundStyle(isSelected ? .mPink3 : .gray5)
                    
//                    Text(viewModel.)
//                        .font(.m4b)
//                        .foregroundStyle(isSelected ? .mPink3 : .gray5)
                }
                
                Rectangle()
                    .fill(isSelected ? .mPink3 : .clear)
                    .frame(height: 2)
            }
        }
    }
}

#Preview {
    MyCampaignView()
} 
