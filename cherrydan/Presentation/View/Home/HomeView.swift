import SwiftUI
import AuthenticationServices

struct HomeView: View {
    @EnvironmentObject var router: HomeRouter
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCampaignPopup = false
    @State private var showSortBottomSheet = false
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDHeaderWithLeftContent(onSearchClick: {
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
//                    CampaignBanner(banners: viewModel.banners)
//                        .padding(.top, 8)
//                        .padding(.bottom, 16)
                    
                    CDTabSection(
                        selectedCategory: $viewModel.selectedCategory,
                        onCategoryChanged: viewModel.selectCategory
                    )
                    
                    Divider()
                        .padding(.bottom, 16)
                    
                    sortSection
                    tagSection
                    campaignGridSection
                    
                    if viewModel.isLoadingMore {
                        loadingIndicator
                    }
                }
            }
        }
        .sheet(isPresented: $showSortBottomSheet) {
            SortBottomSheet(
                isPresented: $showSortBottomSheet,
                selectedSortType: $viewModel.selectedSortType,
                onSortTypeSelected: viewModel.selectSortType
            )
        }
        .animation(.fastEaseInOut, value: viewModel.selectedSortType)
        .onViewDidLoad {
            viewModel.fetchBannerData()
        }
    }
    
    private var sortSection: some View {
        HStack {
            if viewModel.selectedCategory == .region {
                HStack(spacing: 0) {
                    Button(action: {
                        router.push(to: .selectRegion(viewModel: viewModel))
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
        let tags = viewModel.getTagsForCurrentCategory()
        
        return VStack(alignment: .leading, spacing: 0) {
            if !tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            tagButton(tag)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 12)
            }
        }
    }
    
    private func tagButton(_ tag: String) -> some View {
        let isSelected = viewModel.selectedTags.contains(tag)
        
        return Button(action: {
            viewModel.toggleTag(tag)
        }) {
            Text(tag)
                .font(.m5r)
                .foregroundStyle(isSelected ? .gray9 : .gray5)
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
                Button(action:{
                    router.push(to: .campaignWeb(
                        campaignSite: campaign.campaignSite,
                        campaignSiteUrl: campaign.detailUrl
                    ))
                }){
                    CampaignCardView(campaign: campaign)
                }
                .onAppear {
                    // 마지막에서 10번째 아이템이 나타날 때 다음 페이지 로드 (더 자연스러운 스크롤)
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
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(0.8)
            Spacer()
        }
        .frame(height: 60)
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeRouter())
}
