import Foundation

@MainActor
class KeywordNotificationDetailViewModel: ObservableObject {
    @Published var campaigns: [Campaign] = []
    @Published var campaignCount: Int = 0
    @Published var isLoading: Bool = false
    @Published var hasNextPage: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private let keywordRepository: KeywordRepository
    private let bookmarkRepository: BookmarkRepository
    private var currentPage: Int = 0
    
    let keyword: KeywordNotification
    
    init(keyword: KeywordNotification,
         keywordRepository: KeywordRepository = KeywordRepository(),
         bookmarkRepository: BookmarkRepository = BookmarkRepository()
    ) {
        self.keyword = keyword
        self.keywordRepository = keywordRepository
        self.bookmarkRepository = bookmarkRepository
        loadCampaigns()
    }
    
    /// 특정 키워드로 맞춤형 캠페인 로드
    func loadCampaigns() {
        Task {
            do {
                isLoading = true
                let response = try await keywordRepository.getPersonalizedCampaignsByKeyword(
                    keyword: keyword.keyword,
                    date: keyword.alertDate,
                    page: currentPage
                )
                campaignCount = response.result.totalElements
                campaigns = response.result.content.map { $0.toCampaign() }
                hasNextPage = response.result.hasNext
                currentPage = response.result.page + 1
            } catch {
                ToastManager.shared.show(.errorWithMessage("캠페인을 불러오는 중 오류가 발생했습니다."))
            }
            
            isLoading = false
        }
    }
    
    func loadNextPage() {
        guard hasNextPage && !isLoadingMore else { return }
        
        
        Task {
            do {
                isLoadingMore = true
                let response = try await keywordRepository.getPersonalizedCampaignsByKeyword(
                    keyword: keyword.keyword,
                    date: keyword.alertDate,
                    page: currentPage
                )
                
                campaigns.append(contentsOf: response.result.content.map { $0.toCampaign() })
                hasNextPage = response.result.hasNext
                currentPage = response.result.page + 1
            } catch {
                print("KeywordNotificationDetailViewModel LoadMore Error: \(error)")
                ToastManager.shared.show(.errorWithMessage("추가 캠페인을 불러오는 중 오류가 발생했습니다."))
            }
            
            isLoadingMore = false
        }
    }
    
    func toggleBookmark(for campaign: Campaign) {
        Task {
            do {
                if campaign.isBookmarked {
                    try await bookmarkRepository.cancelBookmark(campaignId: campaign.id)
                    if let index = campaigns.firstIndex(where: { $0.id == campaign.id }) {
                        campaigns[index].isBookmarked = false
                    }
                } else {
                    try await bookmarkRepository.addBookmark(campaignId: campaign.id)
                    if let index = campaigns.firstIndex(where: { $0.id == campaign.id }) {
                        campaigns[index].isBookmarked = true
                    }
                }
            } catch {
                print("북마크 토글 오류: \(error)")
                ToastManager.shared.show(.errorWithMessage("북마크 처리 중 오류가 발생했습니다."))
            }
        }
    }
}
