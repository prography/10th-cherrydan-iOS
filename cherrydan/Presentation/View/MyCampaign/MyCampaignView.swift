import SwiftUI

struct MyCampaignView: View {
    @EnvironmentObject private var router: MyCampaignRouter
    @StateObject private var viewModel = MyCampaignViewModel()
    
    @State private var isShowingChangeStatusBottomSheet = false
    @State private var selectedStatusForChange: CampaignStatusType? = nil
    
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
            
            CDSelectSection(
                isDeleteMode: $viewModel.isDeleteMode,
                toggleSelectAll: {
                    viewModel.toggleSelectAll()
                },
                rightButtonText: "상태 변경",
                onRightButtonClick: {
                    isShowingChangeStatusBottomSheet = true
                },
                onClickDelete: {
                    viewModel.deleteSelectedCampaigns()
                },
                isAllSelected: viewModel.isAllSelected,
                isSelectionValid: viewModel.isSelectionValid
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            campaignListSection
        }
        .animation(.mediumSpring, value: viewModel.isShowingClosedCampaigns)
        .sheet(isPresented: $isShowingChangeStatusBottomSheet) {
            ChangeCampaignStatusBottomSheet(
                isPresented: $isShowingChangeStatusBottomSheet,
                selectedStatus: $selectedStatusForChange,
                onStatusSelected: { status in
                    viewModel.updateSelectedCampaignsStatus(to: status)
                    isShowingChangeStatusBottomSheet = false
                    selectedStatusForChange = nil
                }
            )
        }
    }
    
    @ViewBuilder
    private var campaignListSection: some View {
        if !viewModel.isShowingClosedCampaigns {
            openSection
        } else {
            closedCampaignListSection
                .transition(.move(edge: .trailing))
        }
    }
    
    private var openSectionPlaceholder: some View {
        VStack(spacing: 12) {
            Text("\(viewModel.mainSectionTitle)가 없어요")
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
                LazyVStack(spacing: 0) {
                    ForEach(Array(zip(viewModel.mainCampaigns.indices, viewModel.mainCampaigns)), id: \.1.id) { index, campaign in
                        VStack(spacing: 0) {
                            if viewModel.selectedCampaignStatus == .applied {
                                if shouldShowSectionTitle(at: index, for: campaign) {
                                    sectionTitle(for: campaign)
                                        .padding(.top, index == 0 ? 0 : 20)
                                }
                            }
                            
                            MyCampaignRow(
                                myCampaign: campaign,
                                buttonConfigs: viewModel.getMainButtonConfigs(for: campaign, router: router),
                                isDeleteMode: viewModel.isDeleteMode,
                                isSelected: viewModel.selectedCampaignIds.contains(campaign.campaignId),
                                onSelectionToggle: {
                                    viewModel.toggleCampaignSelection(campaignId: campaign.campaignId)
                                }
                            )
                            .onAppear {
                                if !viewModel.isShowingClosedCampaigns,
                                   index == viewModel.mainCampaigns.count - 10,
                                   viewModel.hasMoreOpenPages,
                                   !viewModel.isLoading {
                                    viewModel.loadNextPage()
                                }
                            }
                            
                            if index < viewModel.mainCampaigns.count - 1 {
                                Divider()
                                    .padding(.vertical, 12)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            if viewModel.hasClosedSection {
                closedSectionButton
            }
        }
        .transition(.move(edge: .leading))
    }
    
    private var closedSectionButton: some View {
        Button(action: {
            viewModel.isShowingClosedCampaigns = true
            viewModel.handleToggleClosed(true)
        }) {
            HStack{
                Text(viewModel.closedSectionTitle ?? "")
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
                    Text(viewModel.closedSectionTitle ?? "")
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
                        buttonConfigs: viewModel.getClosedButtonConfigs(for: campaign, router: router),
                        isDeleteMode: viewModel.isDeleteMode,
                        isSelected: viewModel.selectedCampaignIds.contains(campaign.campaignId),
                        onSelectionToggle: {
                            viewModel.toggleCampaignSelection(campaignId: campaign.campaignId)
                        }
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
                    ForEach(CampaignStatusCategory.allCases, id: \.self) { category in
                        tabItem(category)
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Divider()
        }
    }
    
    // MARK: - Section Title Helper Methods
    private func shouldShowSectionTitle(at index: Int, for campaign: MyCampaign) -> Bool {
        // 첫 번째 아이템이거나, 이전 아이템과 subStatusLabel이 다른 경우
        if index == 0 {
            return true
        }
        
        let previousCampaign = viewModel.mainCampaigns[index - 1]
        return campaign.subStatusLabel != previousCampaign.subStatusLabel
    }
    
    @ViewBuilder
    private func sectionTitle(for campaign: MyCampaign) -> some View {
        let title = getSectionTitle(for: campaign.subStatusLabel)
        
        HStack {
            Text(title)
                .font(.m3b)
                .foregroundStyle(.gray9)
            Spacer()
        }
        .padding(.bottom, 20)
    }
    
    private func getSectionTitle(for subStatusLabel: String?) -> String {
        switch subStatusLabel {
        case "waiting":
            return "발표 기다리는 중"
        case "completed":
            return "결과 발표 완료"
        default:
            return "발표 기다리는 중"
        }
    }
    
    @ViewBuilder
    private func tabItem(_ category: CampaignStatusCategory) -> some View {
        let isSelected = category == viewModel.selectedCampaignStatus
        Button(action: {
            viewModel.selectedCampaignStatus = category
        }) {
            
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Text(category.displayText)
                        .font(.m4b)
                        .foregroundStyle(isSelected ? .mPink3 : .gray5)
                    
                    if let count = viewModel.getCountForStatus(category) {
                        Text("\(count)")
                            .font(.m4b)
                            .foregroundStyle(isSelected ? .mPink3 : .gray5)
                    }
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
