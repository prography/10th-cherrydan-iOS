import Foundation
import SwiftUI
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var autoCompleteResults: [SearchRecord] = []
    @Published var searchResults: [Campaign] = []
    @Published var recentSearches: [SearchRecord] = []
    @Published var isLoading: Bool = false
    @Published var isSubmitted: Bool = false
    @Published var totalCount: Int = 0
    @Published var currentPage: Int = 0
    @Published var hasMorePages: Bool = false
    
    @Published var selectedRegionGroups: [RegionGroup] = []
    @Published var selectedSubRegions: [SubRegion] = []
    @Published var selectedLocalCategories: [LocalCategory] = []
    @Published var selectedProductCategories: [ProductCategory] = []
    @Published var selectedSnsPlatforms: [SocialPlatformType] = []
    @Published var selectedCampaignPlatforms: [CampaignPlatformType] = []
    @Published var selectedApplyStart: String? = nil
    @Published var selectedApplyEnd: String? = nil
    @Published var selectedSortType: SortType = .popular
    
    private let campaignRepository: CampaignRepository
    private let searchRecordRepository: SearchRecordRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(
        campaignRepository: CampaignRepository = CampaignRepository(),
        searchRecordRepository: SearchRecordRepository = SearchRecordRepository()
    ) {
        self.campaignRepository = campaignRepository
        self.searchRecordRepository = searchRecordRepository
        
        setupSearchTextObserver()
        loadRecentSearches()
    }
    
    // MARK: - 텍스트 변경 감지 및 디바운스
    private func setupSearchTextObserver() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task {
                    await self?.handleSearchTextChange(searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 검색 텍스트 변경 처리
    private func handleSearchTextChange(_ text: String) async {
        if text.isEmpty {
            autoCompleteResults = []
            isSubmitted = false
            return
        }
        
        if !isSubmitted {
            await searchForAutoComplete(text)
        }
    }
    
    // MARK: - 자동완성 검색 (세로 리스트용)
    private func searchForAutoComplete(_ query: String) async {
        isLoading = true
        
        do {
            let response = try await campaignRepository.searchCampaigns(query)
            
            autoCompleteResults = response.map { campaign in
                SearchRecord(id: "\(campaign.id)", text: campaign.title ?? "", createdAt: "")
            }
        } catch {
            print("Auto complete search error: \(error)")
        }
        isLoading = false
    }
    
    /// 정렬 타입 변경
    func selectSortType(_ sortType: SortType) {
        Task {
            selectedSortType = sortType
            await performSearch()
        }
    }
    // MARK: - 검색 제출 (그리드 형태용)
    func submitSearch() {
        guard !searchText.isEmpty else { return }
        
        isSubmitted = true
        currentPage = 0
        searchResults = []
        
        Task {
            await performSearch()
            await saveSearchRecord()
        }
    }
    
    // MARK: - 실제 검색 수행
    private func performSearch() async {
        isLoading = true
        
        do {
            let response = try await campaignRepository.searchCampaignsByCategory(
                query: searchText,
                regionGroups: selectedRegionGroups,
                subRegions: selectedSubRegions,
                local: selectedLocalCategories,
                product: selectedProductCategories,
                snsPlatform: selectedSnsPlatforms,
                campaignPlatform: selectedCampaignPlatforms,
                sort: selectedSortType,
                page: currentPage,
                size: 20,
                focusedCategory: .all,
                isReporter: false
            )
            
            let campaigns = response.content.map { $0.toCampaign() }
            
            if currentPage == 0 {
                searchResults = campaigns
            } else {
                searchResults.append(contentsOf: campaigns)
            }
            
            totalCount = response.totalElements
            hasMorePages = response.hasNext
        } catch {
            print("Search error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - 다음 페이지 로드
    func loadNextPage() {
        guard hasMorePages, !isLoading else { return }
        
        currentPage += 1
        
        Task {
            await performSearch()
        }
    }
    
    // MARK: - 검색 기록 저장
    private func saveSearchRecord() async {
        do {
            try searchRecordRepository.saveSearchResult(searchText)
            loadRecentSearches()
        } catch {
            print("Save search record error: \(error)")
        }
    }
    
    // MARK: - 최근 검색 기록 불러오기
    func loadRecentSearches() {
        Task {
            do {
                let records = try searchRecordRepository.getSearchRecords()
                recentSearches = records
                    .sorted { $0.createdAt > $1.createdAt }
            } catch {
                print("Load recent searches error: \(error)")
            }
        }
    }
    
    // MARK: - 검색 기록 삭제
    func deleteSearchRecord(_ id: String) {
        Task {
            do {
                try searchRecordRepository.deleteSearchResult(id)
                loadRecentSearches()
            } catch {
                print("Delete search record error: \(error)")
            }
        }
    }
    
    // MARK: - 모든 검색 기록 삭제
    func deleteAllSearchRecords() {
        Task {
            do {
                for record in recentSearches {
                    try searchRecordRepository.deleteSearchResult(record.id)
                }
                loadRecentSearches()
            } catch {
                print("Delete all search records error: \(error)")
            }
        }
    }
    
    // MARK: - 최근 검색어 선택
    func selectRecentSearch(_ text: String) {
        searchText = text
        submitSearch()
    }
    
    // MARK: - 자동완성 결과 선택
    func selectAutoCompleteResult(_ result: SearchRecord) {
        searchText = result.text
        submitSearch()
    }
    
    // MARK: - 검색 초기화
    func resetSearch() {
        searchText = ""
        autoCompleteResults = []
        searchResults = []
        isSubmitted = false
        currentPage = 0
        totalCount = 0
        hasMorePages = false
    }
    
    // MARK: - 필터 관련 메서드들
    func updateRegionGroups(_ regionGroups: [RegionGroup]) {
        selectedRegionGroups = regionGroups
        if isSubmitted {
            refreshSearch()
        }
    }
    
    func updateSubRegions(_ subRegions: [SubRegion]) {
        selectedSubRegions = subRegions
        if isSubmitted {
            refreshSearch()
        }
    }
    
    func updateLocalCategories(_ localCategories: [LocalCategory]) {
        selectedLocalCategories = localCategories
        print(selectedLocalCategories)
        if isSubmitted {
            refreshSearch()
        }
    }
    
    func updateProductCategories(_ productCategories: [ProductCategory]) {
        selectedProductCategories = productCategories
        if isSubmitted {
            refreshSearch()
        }
    }
    
    func updateSnsPlatforms(_ snsPlatforms: [SocialPlatformType]) {
        selectedSnsPlatforms = snsPlatforms
        if isSubmitted {
            refreshSearch()
        }
    }
    
    func updateCampaignPlatforms(_ campaignPlatforms: [CampaignPlatformType]) {
        selectedCampaignPlatforms = campaignPlatforms
        
        if isSubmitted {
            refreshSearch()
        }
    }
    
    func updateApplyDateRange(start: String?, end: String?) {
        selectedApplyStart = start
        selectedApplyEnd = end
        if isSubmitted {
            refreshSearch()
        }
    }
    
    func updateSortType(_ sortType: SortType) {
        selectedSortType = sortType
        if isSubmitted {
            refreshSearch()
        }
    }
    
    private func refreshSearch() {
        currentPage = 0
        searchResults = []
        
        Task {
            await performSearch()
        }
    }
    
    // MARK: - 필터 초기화
    func resetFilters() {
        selectedRegionGroups = []
        selectedSubRegions = []
        selectedLocalCategories = []
        selectedProductCategories = []
        selectedSnsPlatforms = []
        selectedCampaignPlatforms = []
        selectedApplyStart = nil
        selectedApplyEnd = nil
        selectedSortType = .popular
        
        if isSubmitted {
            refreshSearch()
        }
    }
} 
