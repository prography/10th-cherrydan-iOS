import Foundation

@MainActor
class MyCampaignViewModel: ObservableObject {
    @Published var likedCampaigns: [MyCampaign] = []
    @Published var likedClosedCampaigns: [MyCampaign] = []
//    @Published var appliedCampaigns: [MyCampaign] = []
//    @Published var selectedCampaigns: [MyCampaign] = []
//    @Published var nonSelectedCampaigns: [MyCampaign] = []
//    @Published var registeredCampaigns: [MyCampaign] = []
//    @Published var endedCampaigns: [MyCampaign] = []
    
    @Published var isLoading: Bool = false
    
    @Published var currentPage: Int = 0
    @Published var hasMorePages: Bool = true
    @Published var isLoadingMore: Bool = false
    
    @Published var isShowingClosedCampaigns: Bool = false
        
    private let bookmarkRepository: BookmarkRepository
    
    init(bookmarkRepository: BookmarkRepository = BookmarkRepository()) {
        self.bookmarkRepository = bookmarkRepository
        initializeFetch()
    }
    
    func initializeFetch()  {
        isLoading = true
        currentPage = 0
        likedCampaigns = []
        likedClosedCampaigns = []
        hasMorePages = true
        
        Task {
            do {
                let response: BookmarkListResponseDTO = try await bookmarkRepository.getBookmarks(
                    page: currentPage
                )
                
                likedCampaigns = response.open.content.map{ $0.toMyCampaign() }
                
                likedClosedCampaigns = response.closed.content.map{ $0.toMyCampaign() }
            } catch {
                print("Error fetching campaigns: \(error)")
            }
            isLoading = false
        }
    }
    
    func loadNextPage() {
        guard hasMorePages && !isLoadingMore else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        Task {
            do {
                let response: BookmarkListResponseDTO = try await bookmarkRepository.getBookmarks(
                    page: currentPage
                )
                
                likedCampaigns.append(contentsOf: response.open.content.map { $0.toMyCampaign() })
            } catch {
                print("Error loading next page: \(error)")
                // 에러 발생 시 currentPage를 다시 원래대로 복원
                currentPage -= 1
            }
            
            isLoadingMore = false
        }
    }
}
