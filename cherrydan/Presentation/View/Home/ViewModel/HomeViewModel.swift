import Foundation
import Combine
import SwiftUI
import AuthenticationServices

@MainActor
class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var campaigns: [Campaign] = []
    @Published var banners: [NoticeBoardBanner] = []
    @Published var selectedSortType: SortType = .popular
    @Published var totalCnt: Int = 0
    @Published var selectedTags: Set<String> = []
    @Published var selectedCategory: CampaignType = .all
    @Published var selectedRegionGroup: RegionGroup? = nil
    @Published var selectedSubRegion: SubRegion? = nil
    
    @Published var currentPage: Int = 0
    @Published var hasMorePages: Bool = true
    @Published var isLoadingMore: Bool = false
    
    // 캠페인 플랫폼 캐싱을 위한 상태 변수
    @Published var campaignPlatforms: [CampaignPlatform] = []
    @Published var isLoadingCampaignPlatforms: Bool = false
    
    private let campaignAPI: CampaignRepository
    private let noticeBoardAPI: NoticeBoardRepository
    
    var regionGroups: [RegionGroup] {
        if let selectedRegionGroup {
            return [selectedRegionGroup]
        } else {
            return []
        }
    }
    
    var subRegions: [SubRegion] {
        if let selectedSubRegion {
            return [selectedSubRegion]
        } else {
            return []
        }
    }
    
    var selectedRegion: String {
        if let selectedSubRegion {
            return selectedSubRegion.displayName
        }
        
        if let selectedRegionGroup {
            return selectedRegionGroup.displayName
        }
        
        return "지역 전체"
    }
    
    // 태그 데이터를 캐싱하는 computed property
    var tagDatas: [TagData] {
        getTagsForCurrentCategory()
    }
    
    init(
        campaignAPI: CampaignRepository = CampaignRepository(),
        noticeBoardAPI: NoticeBoardRepository = NoticeBoardRepository()
    ) {
        self.campaignAPI = campaignAPI
        self.noticeBoardAPI = noticeBoardAPI
        initializeFetch()
    }
    
    func fetchBannerData() {
        isLoading = true
        
        Task {
            do {
                let response = try await noticeBoardAPI.getNoticeBoardBanner()
                
                banners = response.result.map{$0.toNoticeBoardBanner()}
            } catch {
                print("Error fetching banners: \(error)")
                errorMessage = "캠페인을 불러오는 중 오류가 발생했습니다."
            }
            
            isLoading = false
        }
    }
    
    
    func fetchCampaigns(for category: CampaignType) async throws -> [Campaign] {
        let response: PageableResponse<CampaignDTO>
        
        switch category {
        case .all:
            response = try await campaignAPI.getAllCampaign(
                sort: selectedSortType,
                page: currentPage
            )
        case .region:
            response = try await campaignAPI.getCampaignByRegion(
                regionGroups: regionGroups,
                subRegions: subRegions,
                local: getLocalCategoriesForCurrentCategory(),
                sort: selectedSortType,
                page: currentPage
            )
            
        case .product:
            response = try await campaignAPI.getCampaignByProduct(
                getProductCategoriesForCurrentCategory(),
                sort: selectedSortType,
                page: currentPage
            )
            
        case .snsPlatform:
            response = try await campaignAPI.getCampaignBySNSPlatform(
                getSocialPlatformsForCurrentCategory(),
                sort: selectedSortType,
                page: currentPage
            )
            
        case .campaignPlatform:
            response = try await campaignAPI.getCampaignByCampaignPlatform(
                getCampaignPlatformsForCurrentCategory(),
                sort: selectedSortType,
                page: currentPage
            )
            
        }
        
        totalCnt = response.totalElements
        hasMorePages = response.hasNext
        
        return response.content.map { $0.toCampaign() }
    }
    
    /// 화면 처음 진입 및 카테고리 변경 시 호출되는 api입니다.
    /// 인피니티 스크롤을 초기화합니다.
    func initializeFetch() {
        isLoading = true
        currentPage = 0
        campaigns = []
        hasMorePages = true
        
        Task {
            do {
                campaigns = try await fetchCampaigns(for: selectedCategory)
            } catch {
                print("Error fetching campaigns: \(error)")
                errorMessage = "캠페인을 불러오는 중 오류가 발생했습니다."
            }
            
            isLoading = false
        }
    }
    
    /// 인피니트 스크롤을 수행합니다.
    func loadNextPage() {
        guard hasMorePages && !isLoadingMore else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        Task {
            do {
                let newCampaigns = try await fetchCampaigns(for: selectedCategory)
                campaigns.append(contentsOf: newCampaigns)
            } catch {
                print("Error loading next page: \(error)")
                errorMessage = "추가 캠페인을 불러오는 중 오류가 발생했습니다."
                // 에러 발생 시 currentPage를 다시 원래대로 복원
                currentPage -= 1
            }
            
            isLoadingMore = false
        }
    }
    
    /// 정렬 타입 변경
    func selectSortType(_ sortType: SortType) {
        selectedSortType = sortType
        initializeFetch()
    }
    
    func selectCategory(_ category: CampaignType) {
        selectedCategory = category
        if category != .region {
            selectedRegionGroup = nil
            selectedSubRegion = nil
        }
        
        selectedTags.removeAll()
        
        // 캠페인 플랫폼 카테고리로 변경 시 데이터 미리 로드
        if category == .campaignPlatform && campaignPlatforms.isEmpty {
            Task {
                await loadCampaignPlatforms()
            }
        }
        
        selectedTags.insert("전체")
        initializeFetch()
    }
    
    /// 지역 변경
    func selectRegion(_ regionGroup: RegionGroup? = nil, _ subRegion: SubRegion? = nil) {
        selectedRegionGroup = nil
        selectedSubRegion = nil
        
        if let regionGroup {
            selectedRegionGroup = regionGroup
        }
        
        if let subRegion {
            selectedSubRegion = subRegion
        }
        
        initializeFetch()
    }
    
    /// 태그 선택/해제
    func toggleTag(_ tag: String) {
        if tag == "전체" {
            selectedTags = ["전체"]
        } else {
            selectedTags.remove("전체")
            
            if selectedTags.contains(tag) {
                selectedTags.remove(tag)
                if selectedTags.isEmpty {
                    selectedTags.insert("전체")
                }
            } else {
                selectedTags.insert(tag)
            }
        }
        
        initializeFetch()
    }
    
    func getTagsForCurrentCategory() -> [TagData] {
        switch selectedCategory {
        case .all:
            return []
        case .region:
            return [TagData(imgUrl: nil, name: "전체")] + LocalCategory.allCases.map{TagData(imgUrl: nil, name: $0.displayName)}
        case .product:
            return [TagData(imgUrl: nil, name: "전체")] + ProductCategory.allCases.map{TagData(imgUrl: nil, name: $0.displayName)}
        case .snsPlatform:
            return [TagData(imgUrl: nil, name: "전체")] + SocialPlatformType.allCases.map{TagData(imgUrl: nil, name: $0.rawValue)}
        case .campaignPlatform:
            return getCampaignPlatformTabs()
        }
    }
    
    
    func getCampaignPlatformTabs() -> [TagData] {
        // 캐시된 데이터가 있으면 반환
        if !campaignPlatforms.isEmpty {
            return [TagData(imgUrl: nil, name: "전체")] + campaignPlatforms.map { TagData(imgUrl: $0.cdnUrl, name: $0.siteNameKr) }
        }
        
        // 로딩 중이거나 캐시된 데이터가 없으면 빈 배열 반환
        return []
    }
    
    @MainActor
    private func loadCampaignPlatforms() async {
        guard !isLoadingCampaignPlatforms else { return }
        
        isLoadingCampaignPlatforms = true
        
        do {
            let response = try await campaignAPI.getCampaignSites()
            campaignPlatforms = response
        } catch {
            print("Error loading campaign platforms: \(error)")
        }
        
        isLoadingCampaignPlatforms = false
    }
    
    // MARK: - Private Helper Methods
    
    /// 현재 카테고리와 선택된 태그에 따른 지역 카테고리 반환
    private func getLocalCategoriesForCurrentCategory() -> [LocalCategory] {
        guard selectedCategory == .region else { return [] }
        
        return selectedTags.compactMap { tag in
            LocalCategory.from(displayName: tag)
        }
    }
    
    /// 현재 카테고리와 선택된 태그에 따른 제품 카테고리 반환
    private func getProductCategoriesForCurrentCategory() -> [ProductCategory] {
        guard selectedCategory == .product else { return [] }
        
        return selectedTags.compactMap { tag in
            ProductCategory.from(displayName: tag)
        }
    }
    
    /// 현재 카테고리와 선택된 태그에 따른 SNS 플랫폼 반환
    private func getSocialPlatformsForCurrentCategory() -> [SocialPlatformType] {
        guard selectedCategory == .snsPlatform else { return [] }
        
        return selectedTags.compactMap { tag in
            SocialPlatformType.from(displayName: tag)
        }
    }
    
    /// 현재 카테고리와 선택된 태그에 따른 캠페인 플랫폼 반환
    private func getCampaignPlatformsForCurrentCategory() -> [CampaignPlatformType] {
        guard selectedCategory == .campaignPlatform else { return [] }
        
        return selectedTags.compactMap { tag in
            CampaignPlatformType.from(displayName: tag)
        }
    }
}

