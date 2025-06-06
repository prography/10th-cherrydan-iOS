import Foundation
import Combine
import SwiftUI


enum HomeDestination: Hashable {
    case category
    case search
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var navigationPath = NavigationPath()
    
    init() {}
    
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
    
    /// 운동 상세 화면으로 이동
    func navigateTo(_ view: HomeDestination) {
        navigationPath.append(view)
    }
    
    /// 네비게이션 스택 초기화
    func resetNavigation() {
        navigationPath = NavigationPath()
    }
    
    /// 이전 화면으로 돌아가기
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
}

