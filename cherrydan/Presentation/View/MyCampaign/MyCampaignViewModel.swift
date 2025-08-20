import Foundation

@MainActor
class MyCampaignViewModel: ObservableObject {
    @Published var likedCampaigns: [MyCampaign] = []
    @Published var likedClosedCampaigns: [MyCampaign] = []
    @Published var selectedCampaignStatus: CampaignStatusType = .apply
    
    @Published var isLoading: Bool = false
    
    @Published var currentOpenPage: Int = 0
    @Published var hasMoreOpenPages: Bool = true
    
    @Published var currentClosedPage: Int = 0
    @Published var hasMoreClosedPages: Bool = true
    
    @Published var isLoadingMore: Bool = false
    
    @Published var isShowingClosedCampaigns: Bool = false
        
    private let bookmarkRepository: BookmarkRepository
    
    init(bookmarkRepository: BookmarkRepository = BookmarkRepository()) {
        self.bookmarkRepository = bookmarkRepository
        initializeFetch()
    }
    
    func initializeFetch()  {
        isLoading = true
        currentOpenPage = 0
        currentClosedPage = 0
        likedCampaigns = []
        likedClosedCampaigns = []
        hasMoreOpenPages = true
        hasMoreClosedPages = true
        
        Task {
            do {
                let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getOpenBookmarks(
                    page: currentOpenPage
                )
                likedCampaigns = response.content.map { $0.toMyCampaign() }
                hasMoreOpenPages = response.hasNext
            } catch {
                print("Error fetching campaigns: \(error)")
            }
            isLoading = false
        }
    }
    
    func loadNextPage() {
        if isShowingClosedCampaigns {
            guard hasMoreClosedPages && !isLoadingMore else { return }
            isLoadingMore = true
            currentClosedPage += 1
            Task {
                do {
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getClosedBookmarks(page: currentClosedPage)
                    likedClosedCampaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                    hasMoreClosedPages = response.hasNext
                } catch {
                    print("Error loading next closed page: \(error)")
                    currentClosedPage -= 1
                }
                isLoadingMore = false
            }
        } else {
            guard hasMoreOpenPages && !isLoadingMore else { return }
            isLoadingMore = true
            currentOpenPage += 1
            Task {
                do {
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getOpenBookmarks(page: currentOpenPage)
                    likedCampaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                    hasMoreOpenPages = response.hasNext
                } catch {
                    print("Error loading next open page: \(error)")
                    currentOpenPage -= 1
                }
                isLoadingMore = false
            }
        }
    }

    func handleToggleClosed(_ showClosed: Bool) {
        if showClosed {
            // reset and load first page for closed
            currentClosedPage = 0
            hasMoreClosedPages = true
            likedClosedCampaigns = []
            isLoading = true
            Task {
                do {
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getClosedBookmarks(page: currentClosedPage)
                    likedClosedCampaigns = response.content.map { $0.toMyCampaign() }
                    hasMoreClosedPages = response.hasNext
                } catch {
                    print("Error fetching closed campaigns: \(error)")
                }
                isLoading = false
            }
        }
    }
    
    func cancelBookmark(for campaignId: Int) {
        Task {
            do {
                try await bookmarkRepository.cancelBookmark(campaignId: campaignId)
                if isShowingClosedCampaigns {
                    likedClosedCampaigns.removeAll { $0.campaignId == campaignId }
                } else {
                    likedCampaigns.removeAll { $0.campaignId == campaignId }
                }
            } catch {
                print("북마크 토글 오류: \(error)")
                ToastManager.shared.show(.errorWithMessage("북마크 처리 중 오류가 발생했습니다."))
            }
        }
    }
}
