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
    @Published var selectedCategory: CampaignType = .all
    @Published var totalCnt: Int = 0
    @Published var selectedTags: Set<String> = []
    
    @Published var selectedRegionGroup: RegionGroup? = nil
    @Published var selectedSubRegion: SubRegion? = nil
    
    @Published var currentPage: Int = 0
    @Published var hasMorePages: Bool = true
    @Published var isLoadingMore: Bool = false
    
    private let campaignAPI: CampaignRepository
    private let noticeBoardAPI: NoticeBoardRepository
    
    var selectedRegion: String {
        if let selectedRegionGroup {
            return selectedRegionGroup.displayName
        }
        if let selectedSubRegion {
            return selectedSubRegion.displayName
        }
        
        return "지역 전체"
    }
    
    init(
        campaignAPI: CampaignRepository = CampaignRepository(),
        noticeBoardAPI: NoticeBoardRepository = NoticeBoardRepository()
    ) {
        self.campaignAPI = campaignAPI
        self.noticeBoardAPI = noticeBoardAPI
        fetchCampaigns()
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
    
    func fetchCampaigns() {
        isLoading = true
        currentPage = 0
        campaigns = []
        hasMorePages = true
        
        Task {
            do {
                let response = try await campaignAPI.searchCampaignsByCategory(
                    local: getLocalCategoriesForCurrentCategory(),
                    product: getProductCategoriesForCurrentCategory(),
                    snsPlatform: getSocialPlatformsForCurrentCategory(),
                    campaignPlatform: getCampaignPlatformsForCurrentCategory(),
                    sort: selectedSortType,
                    page: currentPage,
                    size: 20
                )
                
                campaigns = response.content.map { $0.toCampaign() }
                totalCnt = response.totalElements
                hasMorePages = response.hasNext
            } catch {
                print("Error fetching campaigns: \(error)")
                errorMessage = "캠페인을 불러오는 중 오류가 발생했습니다."
            }
            isLoading = false
        }
    }
    
    /// 다음 페이지 로드 (무한 스크롤용)
    func loadNextPage() {
        guard hasMorePages && !isLoadingMore else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        Task {
            do {
                let response = try await campaignAPI.searchCampaignsByCategory(
                    local: getLocalCategoriesForCurrentCategory(),
                    product: getProductCategoriesForCurrentCategory(),
                    snsPlatform: getSocialPlatformsForCurrentCategory(),
                    campaignPlatform: getCampaignPlatformsForCurrentCategory(),
                    sort: selectedSortType,
                    page: currentPage,
                    size: 20
                )
                
                let newCampaigns = response.content.map { $0.toCampaign() }
                campaigns.append(contentsOf: newCampaigns)
                hasMorePages = response.hasNext
                totalCnt = response.totalElements
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
        fetchCampaigns()
    }
    
    /// 카테고리 변경
    func selectCategory(_ category: CampaignType) {
        selectedCategory = category
        selectedTags.removeAll() // 카테고리 변경 시 태그 초기화
        getTagsForCurrentCategory()
        
        fetchCampaigns()
    }
    
    /// 지역 변경
    func selectRegion(_ regionGroup: RegionGroup? = nil, _ subRegion: SubRegion? = nil) {
        if let regionGroup {
            selectedRegionGroup = regionGroup
            fetchCampaigns()
        }
        
        if let subRegion {
            selectedSubRegion = subRegion
            fetchCampaigns()
        }
    }
    
    /// 태그 선택/해제
    func toggleTag(_ tag: String) {
        if tag == "전체" {
            // "전체" 선택 시 다른 모든 태그 해제
            selectedTags = ["전체"]
        } else {
            // 다른 태그 선택 시 "전체" 해제
            selectedTags.remove("전체")
            
            if selectedTags.contains(tag) {
                selectedTags.remove(tag)
                // 모든 태그가 해제되면 "전체" 자동 선택
                if selectedTags.isEmpty {
                    selectedTags.insert("전체")
                }
            } else {
                selectedTags.insert(tag)
            }
        }
        fetchCampaigns()
    }
    
    /// 현재 카테고리에 해당하는 태그 목록 반환
    func getTagsForCurrentCategory() -> [String] {
        switch selectedCategory {
        case .all:
            return []
        case .region:
            return LocalCategory.allCases.map{$0.displayName}
        case .product:
            return ProductCategory.allCases.map{$0.displayName}
//        case .reporter:
//            return []
        case .snsPlatform:
            return SocialPlatformType.allCases.map{$0.rawValue}
        case .campaignPlatform:
            return CampaignPlatformType.allCases.map{$0.rawValue}
        }
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

