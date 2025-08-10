import SwiftUI

struct KeywordAlertDetailView: View {
    @EnvironmentObject var router: HomeRouter
    @StateObject private var viewModel: KeywordAlertDetailViewModel
    
    init(keyword: KeywordNotification) {
        self._viewModel = StateObject(wrappedValue: KeywordAlertDetailViewModel(keyword: keyword))
    }
    
    var body: some View {
        CDScreen(
            horizontalPadding: 0,
            isLoading: viewModel.isLoading || viewModel.isLoadingMore
        ) {
            CDBackHeaderWithTitle(title: "\(viewModel.keyword.keyword) 키워드 알림")
            .padding(.horizontal, 16)
            
            Text("총 \(viewModel.campaignCount)개")
                .font(.m5r)
                .foregroundStyle(.gray4)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !viewModel.isLoading && viewModel.campaigns.isEmpty {
                emptyView
            } else {
                campaignGridSection
            }
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.gray4)
            
            Text("\(viewModel.keyword.keyword) 관련 캠페인이 없습니다")
                .font(.m4r)
                .foregroundColor(.gray5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private var campaignGridSection: some View {
        ScrollView(.vertical, showsIndicators: false) {
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
                    }) {
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
                        // 마지막 10개 아이템이 나타날 때 다음 페이지 로드
                        if index == viewModel.campaigns.count - 10 && viewModel.hasNextPage && !viewModel.isLoadingMore {
                            viewModel.loadNextPage()
                        }
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
    }
}
