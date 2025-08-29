import SwiftUI
import Kingfisher

struct HomeView: View {
    @EnvironmentObject var router: HomeRouter
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var showCampaignPopup = false
    @State private var showSortBottomSheet = false
    @State private var showRegionSideMenu = false
    
    var body: some View {
        ZStack {
            CDScreen(horizontalPadding: 0, isLoading: viewModel.isLoading || viewModel.isLoadingMore) {
                CDHeaderWithLeftContent(
                    onNotificationClick: {
                        if AuthManager.shared.isGuestMode {
                            PopupManager.shared.show(.loginNeeded(onClick: {
                                AuthManager.shared.leaveGuestMode()
                            }))
                        } else {
                            router.push(to: .notification(tab: .activity))
                        }
                    }, onSearchClick: {
                        if AuthManager.shared.isGuestMode {
                            PopupManager.shared.show(.loginNeeded(onClick: {
                                AuthManager.shared.leaveGuestMode()
                            }))
                        } else {
                            router.push(to: .search)
                        }
                    }) {
                        HStack(spacing: 16) {
                            Text("체리단")
                                .font(.t1)
                                .foregroundStyle(.gray9)
                        }
                    }
                    .padding(.horizontal, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        CampaignBanner(banners: viewModel.banners)
                            .padding(.top, 8)
                            .padding(.bottom, 16)
                        
                        CDTabSection(
                            selectedCategory: $viewModel.selectedCategory,
                            onCategoryChanged: viewModel.selectCategory
                        )
                        
                        Divider()
                            .padding(.bottom, 16)
                        
                        sortSection
                        tagSection
                        campaignGridSection
                    }
                }
            }
            
            if showRegionSideMenu {
                Color.black.opacity(0.3)
                    .ignoresSafeArea(.all, edges: .all)
                    .onTapGesture {
                        showRegionSideMenu = false
                    }
                
                RegionSelectionSideMenu(
                    currentRegionGroup: viewModel.selectedRegionGroup,
                    currentSubRegion: viewModel.selectedSubRegion,
                    onSelectRegion: { regionGroup, subRegion in
                        viewModel.selectRegion(regionGroup, subRegion)
                        showRegionSideMenu = false
                    },
                    onDismiss: {
                        showRegionSideMenu = false
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
        .sheet(isPresented: $showSortBottomSheet) {
            SortBottomSheet(
                isPresented: $showSortBottomSheet,
                selectedSortType: $viewModel.selectedSortType,
                onSortTypeSelected: viewModel.selectSortType
            )
        }
        .animation(.fastSpring, value: viewModel.selectedSortType)
        .animation(.mediumSpring, value: showRegionSideMenu)
    }
    
    private var sortSection: some View {
        HStack {
            if viewModel.selectedCategory == .region {
                HStack(spacing: 0) {
                    Button(action: {
                        showRegionSideMenu = true
                    }) {
                        HStack(spacing: 4) {
                            Text(viewModel.selectedRegion)
                                .font(.m2b)
                                .foregroundStyle(.gray9)
                            
                            Text("\(viewModel.totalCnt)개")
                                .font(.m4r)
                                .foregroundStyle(.gray9)
                            Image("chevron_right")
                        }
                    }
                }
            } else {
                Text("총 \(viewModel.totalCnt)개")
                    .font(.m5r)
                    .foregroundStyle(.gray4)
            }
            Spacer()
            
            Button(action: {
                showSortBottomSheet = true
            }) {
                HStack(spacing: 4) {
                    Text(viewModel.selectedSortType.displayName)
                        .font(.m5r)
                        .foregroundStyle(.gray5)
                    
                    Image("chevron_down")
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    private var tagSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !viewModel.tagDatas.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.tagDatas, id: \.self) { tagData in
                            tagButton(tagData)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 12)
            }
        }
    }
    
    private func tagButton(_ tagData: TagData) -> some View {
        let isSelected = viewModel.selectedTags.contains(tagData.name)
        
        return Button(action: {
            viewModel.toggleTag(tagData.name)
        }) {
            HStack(spacing: 2) {
                if let imgName = tagData.imgName, !imgName.isEmpty {
                    Image(imgName)
                        .resizable()
                        .frame(width: 16, height: 16)
                } else if let imgUrl = tagData.imgUrl {
                    KFImage(URL(string: imgUrl))
                        .resizable()
                        .onFailure { error in
                            print("Image loading failed: \(error)")
                        }
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 4)
                }
                
                Text(tagData.name)
                    .font(.m5r)
                    .foregroundStyle(isSelected ? .gray9 : .gray5)
            }
            .frame(height: 28, alignment: .center)
            .padding(.horizontal, 12)
            .background(isSelected ? .pBlue : .gray2, in: RoundedRectangle(cornerRadius: 20))
        }
        .animation(.fastEaseInOut, value: isSelected)
    }
    
    private var campaignGridSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 32) {
            ForEach(Array(zip(viewModel.campaigns.indices, viewModel.campaigns)), id: \.1.id) { index, campaign in
                Button(action: {
                    router.push(to: .campaignWeb(
                        siteNameKr: campaign.campaignSite.siteNameKr,
                        campaignSiteUrl: campaign.detailUrl
                    ))
                }){
                    CampaignCardView(campaign: campaign) {
                        if AuthManager.shared.isGuestMode {
                            PopupManager.shared.show(.loginNeeded(onClick: {
                                AuthManager.shared.leaveGuestMode()
                            }))
                        } else {
                            viewModel.toggleBookmark(for: campaign)
                        }
                    }
                }
                .onAppear {
                    if index == viewModel.campaigns.count - 10 && viewModel.hasMorePages && !viewModel.isLoadingMore {
                        viewModel.loadNextPage()
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
    
    private var loadingIndicator: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeRouter())
}
