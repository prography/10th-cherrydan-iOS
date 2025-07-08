import Foundation
import Combine
import SwiftUI
import AuthenticationServices

enum HomeDestination: Hashable {
    case category
    case search
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var campaigns: [Campaign] = []
    @Published var selectedSortType: SortType = .popular
    @Published var selectedCategory: CampaignType = .all
    @Published var totalCnt: Int = 0
    @Published var selectedTags: Set<String> = []
    
    private let campaignAPI: CampaignRepository
    
    init(campaignAPI: CampaignRepository = CampaignRepository()) {
        self.campaignAPI = campaignAPI
        fetchCampaigns()
    }
    
    func fetchCampaigns() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response: PageableResponse<CampaignDTO>
                
                // 태그가 선택된 경우 searchCampaignsByCategory API 호출
                if !selectedTags.isEmpty && selectedTags != ["전체"] {
                    response = try await campaignAPI.searchCampaignsByCategory(
                        local: getSelectedLocalCategories(),
                        product: getSelectedProductCategories(),
                        snsPlatform: getSelectedSocialPlatforms(),
                        campaignPlatform: getSelectedCampaignPlatforms(),
                        sort: selectedSortType
                    )
                } else {
                    // 태그가 없거나 "전체"만 선택된 경우 기본 API 호출
                    response = try await campaignAPI.getCampaignByType(type: selectedCategory, sortType: selectedSortType)
                }
                
                campaigns = response.content.map { $0.toCampaign() }
                totalCnt = response.totalElements
            } catch {
                print("Error fetching campaigns: \(error)")
                errorMessage = "캠페인을 불러오는 중 오류가 발생했습니다."
            }
            isLoading = false
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
        
        // 태그가 있는 카테고리인 경우 "전체" 자동 선택
        if !getTagsForCurrentCategory().isEmpty {
            selectedTags.insert("전체")
        }
        
        fetchCampaigns()
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
            return LocalCategory.allCasesWithAll
        case .product:
            return ProductCategory.allCasesWithAll
        case .reporter:
            return SocialPlatformType.allCasesWithAll
        case .snsPlatform:
            return SocialPlatformType.allCasesWithAll
        case .campaignPlatform:
            return CampaignPlatformType.allCasesWithAll
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func getSelectedLocalCategories() -> [LocalCategory] {
        guard selectedCategory == .region else { return [] }
        return selectedTags.compactMap { tag in
            LocalCategory.from(displayName: tag)
        }
    }
    
    private func getSelectedProductCategories() -> [ProductCategory] {
        guard selectedCategory == .product else { return [] }
        return selectedTags.compactMap { tag in
            ProductCategory.from(displayName: tag)
        }
    }
    
    private func getSelectedSocialPlatforms() -> [SocialPlatformType] {
        guard selectedCategory == .reporter || selectedCategory == .snsPlatform else { return [] }
        return selectedTags.compactMap { tag in
            SocialPlatformType.from(displayName: tag)
        }
    }
    
    private func getSelectedCampaignPlatforms() -> [CampaignPlatformType] {
        guard selectedCategory == .campaignPlatform else { return [] }
        return selectedTags.compactMap { tag in
            CampaignPlatformType.from(displayName: tag)
        }
    }
}

