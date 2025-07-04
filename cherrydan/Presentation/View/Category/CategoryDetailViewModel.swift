import Foundation
import Combine
import SwiftUI

@MainActor
class CategoryDetailViewModel: ObservableObject {
    @Published var selectedSortType: SortType = .popular
    @Published var campaigns: [Campaign] = []
    @Published var totalCount: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedTabIndex: Int = 0
    
    private let campaignRepository: CampaignRepository
    let region: String
    let isSub: Bool
    
    let categoryTabs = ["전체", "맛집", "뷰티", "숙박", "문화", "배달", "포장", "기타"]
    
    init(region: String, isSub: Bool, campaignRepository: CampaignRepository = CampaignRepository()) {
        self.region = region
        self.isSub = isSub
        self.campaignRepository = campaignRepository
    }
    
    func loadCampaigns() {
        isLoading = true
        errorMessage = nil
        
        
        Task {
            do {
                let localCategory = LocalCategory.from(displayName: categoryTabs[selectedTabIndex])
                let response: PageableResponse<CampaignDTO>
                if isSub {
                    response = try await campaignRepository.getCampaignByCategory(
                        subRegion: [region] ,
                        local: [localCategory],
                        sort: selectedSortType
                    )
                } else {
                    response = try await campaignRepository.getCampaignByCategory(
                        regionGroup: [region] ,
                        local: [localCategory],
                        sort: selectedSortType
                    )
                }
                
                campaigns = response.content.map { Campaign(from: $0) }
                totalCount = response.totalElements
                isLoading = false
            } catch {
                print("Error loading campaigns: \(error)")
                errorMessage = "캠페인을 불러오는 중 오류가 발생했습니다."
                isLoading = false
            }
        }
    }
    
    func changeTab(to index: Int) {
        selectedTabIndex = index
        loadCampaigns()
    }
    
    func selectSortType(_ sortType: SortType) {
        selectedSortType = sortType
        loadCampaigns()
    }
} 
