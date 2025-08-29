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
    
    @Published var selectedCampaignStatus: CampaignStatusCategory = .liked {
        didSet {
            if oldValue != selectedCampaignStatus {
                selectedCampaignIds.removeAll()
                fetchCampaignsForSelectedStatus()
            }
        }
    }
    
    @Published var isLoading: Bool = false
    @Published var isDeleteMode: Bool = false
    @Published var isShowingClosedCampaigns: Bool = false
    
    @Published var currentOpenPage: Int = 0
    @Published var hasMoreOpenPages: Bool = true
    
    @Published var currentClosedPage: Int = 0
    @Published var hasMoreClosedPages: Bool = true
    
    @Published var selectedCampaignIds: Set<Int> = []
    @Published var campaignStatusCounts: CampaignStatusCountDTO? = nil
    
    private let bookmarkRepository: BookmarkRepository
    private let campaignStatusRepository: CampaignStatusRepository
    
    init(
        campaignRepository: CampaignStatusRepository = CampaignStatusRepository(),
        bookmarkRepository: BookmarkRepository = BookmarkRepository()
    ) {
        self.campaignStatusRepository = campaignRepository
        self.bookmarkRepository = bookmarkRepository
        initializeFetch()
    }
    
    func initializeFetch()  {
        fetchCampaignStatusCount()
        fetchCampaignsForSelectedStatus()
    }
    
    func fetchCampaignsForSelectedStatus() {
        isLoading = true
        currentOpenPage = 0
        currentClosedPage = 0
        isShowingClosedCampaigns = false
        
        mainCampaigns = []
        subCampaigns = []
        closedCampaigns = []
        
        hasMoreOpenPages = true
        hasMoreClosedPages = true
        
        Task {
            do {
                switch selectedCampaignStatus {
                case .liked:
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getOpenBookmarks(page: currentOpenPage)
                    mainCampaigns = response.content.map { $0.toMyCampaign() }
                    hasMoreOpenPages = response.hasNext
                    
                case .applied:
                    if let statusType = selectedCampaignStatus.primaryStatusType {
                        let response: PageableResponse<MyCampaignDTO> = try await campaignStatusRepository.getMyCampaings(for: statusType, page: currentOpenPage)
                        mainCampaigns = response.content.map { $0.toMyCampaign() }
                        hasMoreOpenPages = response.hasNext
                    }
                    
                case .result:
                    if let statusType = selectedCampaignStatus.primaryStatusType {
                        let response: PageableResponse<MyCampaignDTO> = try await campaignStatusRepository.getMyCampaings(for: statusType, page: currentOpenPage)
                        mainCampaigns = response.content.map { $0.toMyCampaign() }
                        hasMoreOpenPages = response.hasNext
                    }
                    
                case .writingReview:
                    if let statusType = selectedCampaignStatus.primaryStatusType {
                        let response: PageableResponse<MyCampaignDTO> = try await campaignStatusRepository.getMyCampaings(for: statusType, page: currentOpenPage)
                        mainCampaigns = response.content.map { $0.toMyCampaign() }
                        hasMoreOpenPages = response.hasNext
                    }
                    
                case .writingDone:
                    if let statusType = selectedCampaignStatus.primaryStatusType {
                        let response: PageableResponse<MyCampaignDTO> = try await campaignStatusRepository.getMyCampaings(for: statusType, page: currentOpenPage)
                        mainCampaigns = response.content.map { $0.toMyCampaign() }
                        hasMoreOpenPages = response.hasNext
                    }
                }
            } catch {
                print("Error fetching campaigns: \(error)")
            }
            isLoading = false
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
                    switch selectedCampaignStatus {
                    case .liked:
                        let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getClosedBookmarks(page: currentClosedPage)
                        closedCampaigns = response.content.map { $0.toMyCampaign() }
                        hasMoreClosedPages = response.hasNext
                        
                    case .result:
                        if let statusType = selectedCampaignStatus.secondaryStatusType {
                            let response: PageableResponse<MyCampaignDTO> = try await campaignStatusRepository.getMyCampaings(for: statusType, page: currentClosedPage)
                            closedCampaigns = response.content.map { $0.toMyCampaign() }
                            hasMoreClosedPages = response.hasNext
                        }
                        
                    default:
                        break
                    }
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
    
    var mainSectionTitle: String {
        selectedCampaignStatus.mainSectionTitle
    }
    
    var closedSectionTitle: String? {
        selectedCampaignStatus.closedSectionTitle
    }
    
    var hasClosedSection: Bool {
        selectedCampaignStatus.closedSectionTitle != nil
    }
    
    func getMainButtonConfigs(for campaign: MyCampaign, router: MyCampaignRouter) -> [ButtonConfig] {
        switch selectedCampaignStatus {
        case .liked:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "지원 완료로 변경",
                    type: .smallPrimary,
                    onClick: {
                        PopupManager.shared.show(.confirmStatusChange(status: "지원 완료"){
                            self.changeCampaignStatus(campaignId: campaign.campaignId, to: .apply)
                        }
                        )
                    }
                )
            ]
            
        case .applied:
            if campaign.subStatusLabel == "completed" {
                return [
                    ButtonConfig(
                        text: "공고 보기",
                        type: .smallGray,
                        onClick: {
                            router.push(to: .campaignWeb(
                                siteNameKr: campaign.campaignSite,
                                campaignSiteUrl: campaign.detailUrl
                            ))
                        }
                    ),
                    ButtonConfig(
                        text: "합격/불합격 입력",
                        type: .smallPrimary,
                        onClick: {
                            PopupManager.shared.show(.passFailSelection(
                                onPass: {
                                    self.changeCampaignStatus(campaignId: campaign.campaignId, to: .selected)
                                },
                                onFail: {
                                    self.changeCampaignStatus(campaignId: campaign.campaignId, to: .notSelected)
                                }
                            ))
                        }
                    )
                ]
            } else {
                    return [
                        ButtonConfig(
                            text: "공고 보기",
                            type: .smallGray,
                            onClick: {
                                router.push(to: .campaignWeb(
                                    siteNameKr: campaign.campaignSite,
                                    campaignSiteUrl: campaign.detailUrl
                                ))
                            }
                        )
                    ]
            }
            
        case .result:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "방문 완료로 변경",
                    type: .smallPrimary,
                    onClick: {
                        PopupManager.shared.show(.visitCompletion(
                            onVisitCompleted: {
                                self.changeCampaignStatus(campaignId: campaign.campaignId, to: .reviewing)
                            },
                            onVisitIncomplete: {
                                // 방문 미완료 시 아무 동작 없음
                            }
                        ))
                    }
                )
            ]
            
        case .writingReview:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "리뷰 작성 완료",
                    type: .smallPrimary,
                    onClick: {
                        PopupManager.shared.show(.reviewWritingCompletion(
                            onConfirm: {
                                self.changeCampaignStatus(campaignId: campaign.campaignId, to: .ended)
                            }
                        ))
                    }
                )
            ]
            
        case .writingDone:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallWhite,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                ),
                ButtonConfig(
                    text: "리뷰 결과 확인",
                    type: .smallPrimary,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                )
            ]
        }
    }
    
    func getClosedButtonConfigs(for campaign: MyCampaign, router: MyCampaignRouter) -> [ButtonConfig] {
        switch selectedCampaignStatus {
        case .liked:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallWhite,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                )
            ]
            
        case .result:
            return [
                ButtonConfig(
                    text: "공고 보기",
                    type: .smallGray,
                    onClick: {
                        router.push(to: .campaignWeb(
                            siteNameKr: campaign.campaignSite,
                            campaignSiteUrl: campaign.detailUrl
                        ))
                    }
                )
            ]
            
        default:
            return []
        }
    }
    
    func fetchCampaignStatusCount() {
        Task {
            do {
                let count = try await campaignStatusRepository.getCampaignStatusCount()
                campaignStatusCounts = count
            } catch {
                print("Error fetching campaign status count: \(error)")
            }
        }
    }
    
    func toggleCampaignSelection(campaignId: Int) {
        if selectedCampaignIds.contains(campaignId) {
            selectedCampaignIds.remove(campaignId)
        } else {
            selectedCampaignIds.insert(campaignId)
        }
    }
    
    func toggleSelectAll() {
        let allCampaignIds = Set(mainCampaigns.map { $0.campaignId })
        if selectedCampaignIds == allCampaignIds {
            selectedCampaignIds.removeAll()
        } else {
            selectedCampaignIds = allCampaignIds
        }
    }
    
    var isAllSelected: Bool {
        let allCampaignIds = Set(mainCampaigns.map { $0.campaignId })
        return !allCampaignIds.isEmpty && selectedCampaignIds == allCampaignIds
    }
    
    var isSelectionValid: Bool {
        !selectedCampaignIds.isEmpty
    }
    
    func updateSelectedCampaignsStatus(to newStatus: CampaignStatusType) {
        Task {
            do {
                for campaignId in selectedCampaignIds {
                    let request = CampaignStatusRequestDTO(
                        campaignId: campaignId,
                        status: newStatus.apiValue
                    )
                    _ = try await campaignStatusRepository.createOrRecoverStatus(request: request)
                }
                
                selectedCampaignIds.removeAll()
                fetchCampaignStatusCount()
                fetchCampaignsForSelectedStatus()
                
                ToastManager.shared.show(.success("상태가 성공적으로 변경되었습니다."))
            } catch {
                print("Error updating campaign status: \(error)")
                ToastManager.shared.show(.errorWithMessage("상태 변경 중 오류가 발생했습니다."))
            }
        }
    }
    
    func changeCampaignStatus(campaignId: Int, to statusType: CampaignStatusType) {
        Task {
            do {
                let request = CampaignStatusRequestDTO(
                    campaignId: campaignId,
                    status: statusType.apiValue
                )
                _ = try await campaignStatusRepository.createOrRecoverStatus(request: request)
                
                // 해당 캠페인을 현재 리스트에서 제거
                mainCampaigns.removeAll { $0.campaignId == campaignId }
                
                fetchCampaignStatusCount()
                
                let successMessage = getSuccessMessage(for: statusType)
                ToastManager.shared.show(.success(successMessage))
            } catch {
                print("Error changing campaign status to \(statusType): \(error)")
                ToastManager.shared.show(.errorWithMessage("상태 변경 중 오류가 발생했습니다."))
            }
        }
    }
    
    private func getSuccessMessage(for statusType: CampaignStatusType) -> String {
        switch statusType {
        case .apply:
            return "상태가 성공적으로 변경되었습니다."
        case .reviewing:
            return "리뷰 작성 중으로 상태가 변경되었습니다."
        case .ended:
            return "리뷰 작성이 완료되었습니다."
        case .selected:
            return "선정으로 상태가 변경되었습니다."
        case .notSelected:
            return "미선정으로 상태가 변경되었습니다."
        }
    }
    
    func deleteSelectedCampaigns() {
        Task {
            do {
                switch selectedCampaignStatus {
                case .liked:
                    // 관심공고: 북마크 개별 삭제
                    for campaignId in selectedCampaignIds {
                        try await bookmarkRepository.cancelBookmark(campaignId: campaignId)
                        mainCampaigns.removeAll { $0.campaignId == campaignId }
                    }
                    ToastManager.shared.show(.success("선택된 관심공고가 삭제되었습니다."))
                    
                case .applied, .result, .writingReview, .writingDone:
                    try await campaignStatusRepository.deleteStatus(request: DeleteRequest(campaignIds: Array(selectedCampaignIds)))
                    mainCampaigns.removeAll { selectedCampaignIds.contains($0.campaignId)} }
                
                ToastManager.shared.show(.success("선택된 캠페인 상태가 삭제되었습니다."))
                selectedCampaignIds.removeAll()
                isDeleteMode = false
                fetchCampaignStatusCount()
                
            } catch {
                print("Error deleting campaigns: \(error)")
                ToastManager.shared.show(.errorWithMessage("삭제 중 오류가 발생했습니다."))
            }
        }
    }
    
    func getCountForStatus(_ category: CampaignStatusCategory) -> Int? {
        guard let counts = campaignStatusCounts else { return nil }
        
        switch category {
        case .liked:
            return nil
        case .applied:
            return counts.apply
        case .result:
            return counts.selected + counts.notSelected
        case .writingReview:
            return counts.reviewing
        case .writingDone:
            return counts.ended
        }
    }
}

extension MyCampaignViewModel {
    func loadNextPage() {
        if isShowingClosedCampaigns {
            loadNextClosedPage()
        } else {
            loadNextMainPage()
        }
    }
    
    private func loadNextMainPage() {
        guard hasMoreOpenPages && !isLoading else { return }
        isLoading = true
        currentOpenPage += 1
        
        Task {
            do {
                switch selectedCampaignStatus {
                case .liked:
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getOpenBookmarks(page: currentOpenPage)
                    mainCampaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                    hasMoreOpenPages = response.hasNext
                    
                case .applied, .result, .writingReview, .writingDone:
                    if let statusType = selectedCampaignStatus.primaryStatusType {
                        let response: PageableResponse<MyCampaignDTO> = try await campaignStatusRepository.getMyCampaings(for: statusType, page: currentOpenPage)
                        mainCampaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                        hasMoreOpenPages = response.hasNext
                    }
                }
            } catch {
                print("Error loading next main page: \(error)")
                currentOpenPage -= 1
            }
            isLoading = false
        }
    }
    
    private func loadNextClosedPage() {
        guard hasMoreClosedPages && !isLoading else { return }
        isLoading = true
        currentClosedPage += 1
        
        Task {
            do {
                switch selectedCampaignStatus {
                case .liked:
                    let response: PageableResponse<MyCampaignDTO> = try await bookmarkRepository.getClosedBookmarks(page: currentClosedPage)
                    closedCampaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                    hasMoreClosedPages = response.hasNext
                    
                case .result:
                    if let statusType = selectedCampaignStatus.secondaryStatusType {
                        let response: PageableResponse<MyCampaignDTO> = try await campaignStatusRepository.getMyCampaings(for: statusType, page: currentClosedPage)
                        closedCampaigns.append(contentsOf: response.content.map { $0.toMyCampaign() })
                        hasMoreClosedPages = response.hasNext
                    }
                    
                default:
                    break
                }
            } catch {
                print("Error loading next closed page: \(error)")
                currentClosedPage -= 1
            }
            isLoading = false
        }
    }
}
