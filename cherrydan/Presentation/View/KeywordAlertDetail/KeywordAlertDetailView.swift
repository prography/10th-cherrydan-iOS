import SwiftUI

struct KeywordAlertDetailView: View {
    @EnvironmentObject var router: HomeRouter
    @StateObject private var viewModel: KeywordAlertDetailViewModel
    
    init(keyword: String) {
        self._viewModel = StateObject(wrappedValue: KeywordAlertDetailViewModel(keyword: keyword))
    }
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: "\(viewModel.keyword) 키워드 알림") {
                // 뒤로가기 버튼
            }
            .padding(.horizontal, 16)
            
            if viewModel.isLoading && viewModel.campaigns.isEmpty {
                loadingView
            } else if viewModel.campaigns.isEmpty {
                emptyView
            } else {
                campaignGridSection
            }
        }
        .overlay {
            if viewModel.isLoadingMore {
                loadingMoreIndicator
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("캠페인을 불러오는 중...")
                .font(.m4r)
                .foregroundColor(.gray5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.gray4)
            
            Text("\(viewModel.keyword) 관련 캠페인이 없습니다")
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
                            // 북마크 토글 로직 (필요시 구현)
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
    
    private var loadingMoreIndicator: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(0.8)
                Spacer()
            }
            .frame(height: 60)
            .background(Color.clear)
        }
    }
}

#Preview {
    KeywordAlertDetailView(keyword: "서초")
        .environmentObject(HomeRouter())
} 