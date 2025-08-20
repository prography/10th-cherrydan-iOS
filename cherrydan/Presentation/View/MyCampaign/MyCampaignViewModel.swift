import Foundation

@MainActor
class MyCampaignViewModel: ObservableObject {
    /// - Note: `관심 공고`: 신청 가능한 공고
    ///         `지원한 공고`: 발표 기다리는 중
    ///         `선정 결과`: 선정된 공고
    ///         `리뷰 작성 중`: 리뷰 작성할 공고
    ///         `작성 완료`: 리뷰 작성 완료한 공고
    @Published var mainCampaigns: [MyCampaign] = []
    
    /// - Note: `지원한 공고`: 결과 발표 완료
    @Published var subCampaigns: [MyCampaign] = []
    
    /// - Note: `관심 공고`: 신청 마감된 공고
    ///         `선정 결과`: 선정되지 않은 공고
    @Published var closedCampaigns: [MyCampaign] = []
    
    @Published var selectedCampaignStatus: CampaignStatusType = .apply
    
    @Published var isLoading: Bool = false
    @Published var isDeleteMode: Bool = false
    @Published var isShowingClosedCampaigns: Bool = false
    
    @Published var currentOpenPage: Int = 0
    @Published var hasMoreOpenPages: Bool = true
    
    @Published var currentClosedPage: Int = 0
    @Published var hasMoreClosedPages: Bool = true
    
    private let bookmarkRepository: BookmarkRepository
    private let campaignRepository: CampaignStatusRepository
    
    init(
        campaignRepository: CampaignStatusRepository = CampaignStatusRepository(),
        bookmarkRepository: BookmarkRepository = BookmarkRepository()
    ) {
        self.campaignRepository = campaignRepository
        self.bookmarkRepository = bookmarkRepository
        initializeFetch()
        Task {
            try await fetchCampaigns()
        }
    }
    
    func initializeFetch()  {
        isLoading = true
        currentOpenPage = 0
        currentClosedPage = 0
        
        mainCampaigns = []
        subCampaigns = []
        closedCampaigns = []
        
        hasMoreOpenPages = true
        hasMoreClosedPages = true
        
        Task {
            do {
                let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getOpenBookmarks(
                    page: currentOpenPage
                )
                mainCampaigns = response.content.map { $0.toMyCampaign() }
                hasMoreOpenPages = response.hasNext
            } catch {
                print("Error fetching campaigns: \(error)")
            }
            isLoading = false
        }
    }
    
    func fetchCampaigns() async throws {
        let response: [MyCampaignDTO]
        
        switch selectedCampaignStatus {
        case .apply:
            response = try await campaignRepository.getAllMyStatus().apply
        case .selected:
            response = try await campaignRepository.getAllMyStatus().selected
        case .notSelected:
            response = try await campaignRepository.getAllMyStatus().notSelected
        case .registered:
            response = try await campaignRepository.getAllMyStatus().registered
        case .ended:
            response = try await campaignRepository.getAllMyStatus().ended
        }
        
        mainCampaigns = response.map { $0.toMyCampaign() }
    }
    
    func loadNextPage() {
        switch selectedCampaignStatus {
        case .apply:
            loadNextPageForApply()
        case .selected:
            loadNextPageForApply()
        case .notSelected:
            loadNextPageForApply()
        case .registered:
            loadNextPageForApply()
        case .ended:
            loadNextPageForApply()
        }
    }

    func handleToggleClosed(_ showClosed: Bool) {
        if showClosed {
            currentClosedPage = 0
            hasMoreClosedPages = true
            closedCampaigns = []
            isLoading = true
            
            Task {
                do {
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getClosedBookmarks(page: currentClosedPage)
                    closedCampaigns = response.content.map { $0.toMyCampaign() }
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
                    closedCampaigns.removeAll { $0.campaignId == campaignId }
                } else {
                    mainCampaigns.removeAll { $0.campaignId == campaignId }
                }
            } catch {
                print("북마크 토글 오류: \(error)")
                ToastManager.shared.show(.errorWithMessage("북마크 처리 중 오류가 발생했습니다."))
            }
        }
    }
}

extension MyCampaignViewModel {
    private func loadNextPageForApply() {
        if isShowingClosedCampaigns {
            guard hasMoreClosedPages && !isLoading else { return }
            isLoading = true
            currentClosedPage += 1
            Task {
                do {
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getClosedBookmarks(page: currentClosedPage)
                    closedCampaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                    hasMoreClosedPages = response.hasNext
                } catch {
                    print("Error loading next closed page: \(error)")
                    currentClosedPage -= 1
                }
                isLoading = false
            }
        } else {
            guard hasMoreOpenPages && !isLoading else { return }
            isLoading = true
            currentOpenPage += 1
            Task {
                do {
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getOpenBookmarks(page: currentOpenPage)
                    mainCampaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                    hasMoreOpenPages = response.hasNext
                } catch {
                    print("Error loading next open page: \(error)")
                    currentOpenPage -= 1
                }
                isLoading = false
            }
        }
    }
}
