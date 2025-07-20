import Foundation

@MainActor
class MyCampaignViewModel: ObservableObject {
    @Published var appliedCampaigns: [MyCampaign] = []
    @Published var selectedCampaigns: [MyCampaign] = []
    @Published var nonSelectedCampaigns: [MyCampaign] = []
    @Published var registeredCampaigns: [MyCampaign] = []
    @Published var endedCampaigns: [MyCampaign] = []
    
    @Published var isLoading: Bool = false
    
    private let campaignRepository: CampaignRepository
    
    init(campaignRepository: CampaignRepository = CampaignRepository()) {
        self.campaignRepository = campaignRepository
        loadCampaigns()
    }
    
    func loadCampaigns() {
        isLoading = true
        
        Task {
//            do {
//                let response = try await campaignRepository.getMyCampaignsByStatus()
//                print(response)
//                let campaigns = response.result
//                appliedCampaigns = campaigns.apply.map { $0.toMyCampaign() }
//                nonSelectedCampaigns = campaigns.nonSelected.map { $0.toMyCampaign() }
//                registeredCampaigns = campaigns.registered.map { $0.toMyCampaign() }
//                endedCampaigns = campaigns.ended.map { $0.toMyCampaign() }
//                isLoading = false
//            } catch {
//                print("Error loading campaigns: \(error)")
//                isLoading = false
//            }
        }
    }
//    
//    func changeTab(to index: Int) {
//        selectedTabIndex = index
//        loadCampaigns()
//    }
//    
//    func selectSortType(_ sortType: SortType) {
//        selectedSortType = sortType
//        loadCampaigns()
//    }
}
