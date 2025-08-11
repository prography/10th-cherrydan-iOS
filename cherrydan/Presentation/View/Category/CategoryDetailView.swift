import SwiftUI

struct CategoryDetailView: View {
    @EnvironmentObject private var router: CategoryRouter
    @StateObject private var viewModel: CategoryDetailViewModel
    @State private var isFilterPresent: Bool = false
    
    @State private var headerTitle: String = ""
    init(regionGroup: RegionGroup?, subRegion: SubRegion?) {
        self._viewModel = StateObject(wrappedValue: CategoryDetailViewModel(regionGroup: regionGroup, subRegion: subRegion))
        headerTitle = regionGroup?.displayName ?? subRegion?.displayName ?? "지역"
    }
    
    
    var body: some View {
        ZStack {
            CDScreen(horizontalPadding: 0, isLoading: viewModel.isLoading) {
                CDBackHeaderWithTitle(title: headerTitle){
                    Button(action: {router.push(to: .search)}) {
                        Image("search_bg")
                    }
                }
                .padding(.horizontal, 16)
                
                tabSection
                    .padding(.top, 24)
                
                campaignInfoSection
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8)
                    ], spacing: 16) {
                        ForEach(viewModel.campaigns) { campaign in
                            CampaignCardView(campaign: campaign){} // 카드 최대 높이 제한
                                .onTapGesture {
                                    router.push(to: .campaignWeb(
                                        siteNameKr: campaign.campaignSite.siteNameKr,
                                        campaignSiteUrl: campaign.detailUrl
                                    ))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
                
            }
        }
        .sheet(isPresented: $isFilterPresent) {
            SortBottomSheet(
                isPresented: $isFilterPresent,
                selectedSortType: $viewModel.selectedSortType,
                onSortTypeSelected: viewModel.selectSortType)
        }
        .onAppear {
            viewModel.loadCampaigns()
        }
    }

    private var tabSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(0..<viewModel.categoryTabs.count, id: \.self) { index in
                    Text(viewModel.categoryTabs[index])
                        .font(viewModel.selectedTabIndex == index ? .m3b : .m3r)
                        .foregroundStyle(viewModel.selectedTabIndex == index ? .mPink3 : .gray4)
                        .padding(.bottom, 8)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            viewModel.changeTab(to: index)
                        }
                }
                .padding(.horizontal, 2)
            }
        }
        .animation(.fastEaseInOut, value: viewModel.selectedTabIndex)
    }
    
    private var campaignInfoSection: some View {
        HStack {
            Text("총 \(viewModel.totalCount)개")
                .font(.m4r)
                .foregroundStyle(.gray9)
            
            Spacer()
            
            Button(action: {
                isFilterPresent = true
            }) {
                HStack(spacing: 4) {
                    Text(viewModel.selectedSortType.displayName)
                        .font(.m4r)
                        .foregroundStyle(.gray9)
                    
                    Image("arrow_top")
                        .rotationEffect(.degrees(180))
                }
            }
        }
    }
}
