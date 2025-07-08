import SwiftUI
import AuthenticationServices

struct HomeView: View {
    @EnvironmentObject var router: HomeRouter
    @StateObject private var viewModel = HomeViewModel()
    @State private var showCampaignPopup = false
    @State private var showSortBottomSheet = false
    
    let campaigns = [
        ["체험단 캠페인 여기 다 모았다!", "지금 최고의 체험단에 신청해 보세요.", "1"],
        ["체험단 캠페인 여기 다 모았다!", "지금 최고의 체험단에 신청해 보세요.", "2"],
        ["체험단 캠페인 여기 다 모았다!", "지금 최고의 체험단에 신청해 보세요.", "3"]
    ]
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDHeaderWithLeftContent(onNotificationClick: {
                router.push(to: .notification)
            }, onSearchClick: {
                router.push(to: .search)
            }) {
                HStack(spacing: 16) {
                    Text("체리단")
                        .font(.t1)
                        .foregroundStyle(.gray9)
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    CampaignBanner(campaigns: campaigns)
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
        .sheet(isPresented: $showSortBottomSheet) {
            SortBottomSheet(
                isPresented: $showSortBottomSheet,
                selectedSortType: $viewModel.selectedSortType,
                onSortTypeSelected: viewModel.selectSortType
            )
        }
        .animation(.fastEaseInOut, value: viewModel.selectedSortType)
    }
    
    private var sortSection: some View {
        HStack {
            Text("총 \(viewModel.totalCnt)개")
                .font(.m5r)
                .foregroundStyle(.gray4)
            
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
            ForEach(viewModel.campaigns) { campaign in
                CampaignCardView(campaign: campaign)
                    .frame(maxHeight: 320, alignment: .top)
                    .onTapGesture {
                        router.push(to: .campaignWeb(
                            campaignSite: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
            }
        }
        .padding(.top, 16)
    
        .padding(.horizontal, 16)
    }
}

#Preview {
    HomeView()
}
