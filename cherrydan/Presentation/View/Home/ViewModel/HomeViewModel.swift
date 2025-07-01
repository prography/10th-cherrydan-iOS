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
    private let campaignAPI: CampaignRepository
    
    init(campaignAPI: CampaignRepository = CampaignRepository()) {
        self.campaignAPI = campaignAPI
        fetchCampaigns()
    }
    
    func fetchCampaigns() {
        isLoading = true
        
        defer { isLoading = false }
        Task {
            do {
                if let response = try await campaignAPI.getCampaignTypes() {
                    
                    campaigns = response.content
                }
            } catch {
                print(error.localizedDescription)
                errorMessage = "Asdf"
            }
        }
    }
    
    /// 사용자 프로필 조회
    func fetchUserProfile() {
        isLoading = true
        errorMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isLoading = false
        }
    }
    
    /// 오늘의 운동 현황 조회
    func fetchTodayWorkouts() {
        isLoading = true
        errorMessage = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isLoading = false
        }
    }
    
    /// 운동 현황 새로고침
    func refreshWorkoutStatus() {
        fetchTodayWorkouts()
    }
}

