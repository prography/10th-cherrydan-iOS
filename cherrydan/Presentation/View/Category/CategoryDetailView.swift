import SwiftUI

struct CategoryDetailView: View {
    @EnvironmentObject private var router: CategoryRouter
    @StateObject private var viewModel: CategoryDetailViewModel
    @State private var isFilterPresent: Bool = false
    
    init(region: String, isSub: Bool) {
        self._viewModel = StateObject(wrappedValue: CategoryDetailViewModel(region: region, isSub: isSub))
    }
    
    var body: some View {
        ZStack {
            CDScreen(horizontalPadding: 0) {
                CDBackHeaderWithTitle(title: viewModel.region)
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
                        ForEach(viewModel.campaigns.isEmpty ? Campaign.dummy : viewModel.campaigns) { campaign in
                            CampaignCardView(campaign: campaign)
                                .onTapGesture {
                                    // 캠페인 상세 페이지로 이동
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
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

#Preview {
    CategoryDetailView(region: "서울", isSub: false)
        .environmentObject(CategoryRouter())
} 
