import Foundation

@MainActor
class KeywordAlertDetailViewModel: ObservableObject {
    @Published var campaigns: [Campaign] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasNextPage: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private let keywordRepository: KeywordRepository
    private var currentPage: Int = 0
    private let pageSize: Int = 20
    let keyword: String
    
    init(keyword: String, keywordRepository: KeywordRepository = KeywordRepository()) {
        self.keyword = keyword
        self.keywordRepository = keywordRepository
        Task {
            await loadCampaigns()
        }
    }
    
    /// 특정 키워드로 맞춤형 캠페인 로드
    func loadCampaigns() async {
        isLoading = true
        
        do {
            let response = try await keywordRepository.getPersonalizedCampaignsByKeyword(
                keyword: keyword,
                page: currentPage,
                size: pageSize
            )
            
            campaigns = response.result.content.map { $0.toCampaign() }
            hasNextPage = response.result.hasNext
            currentPage = response.result.page + 1
        } catch {
            print("KeywordAlertDetailViewModel Error: \(error)")
            errorMessage = "캠페인을 불러오는 중 오류가 발생했습니다."
        }
        
        isLoading = false
    }
    
    /// 인피니트 스크롤을 위한 다음 페이지 로드
    func loadNextPage() {
        guard hasNextPage && !isLoadingMore else { return }
        
        isLoadingMore = true
        
        Task {
            do {
                let response = try await keywordRepository.getPersonalizedCampaignsByKeyword(
                    keyword: keyword,
                    page: currentPage,
                    size: pageSize
                )
                
                campaigns.append(contentsOf: response.result.content.map { $0.toCampaign() })
                hasNextPage = response.result.hasNext
                currentPage = response.result.page + 1
            } catch {
                print("KeywordAlertDetailViewModel LoadMore Error: \(error)")
                errorMessage = "추가 캠페인을 불러오는 중 오류가 발생했습니다."
            }
            
            isLoadingMore = false
        }
    }
} 