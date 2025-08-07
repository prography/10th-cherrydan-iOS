import Foundation
import SwiftUI

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var activityNotifications: [ActivityNotification] = []
    @Published var keywordNotifications: [KeywordNotification] = []
    @Published var selectedTab: NotificationType = .activity
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasNextPage: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private let notificationRepository: NotificationRepository
    private var currentPage: Int = 0
    private let pageSize: Int = 20
    
    init(notificationRepository: NotificationRepository = NotificationRepository()) {
        self.notificationRepository = notificationRepository
        Task {
            await loadNotifications()
        }
    }
    
    func loadNotifications() async {
        if selectedTab == .activity {
            await loadActivityNotifications(refresh: true)
        } else {
            await loadKeywordNotifications(refresh: true)
        }
    }
    
    /// 인피니트 스크롤을 위한 다음 페이지 로드
    func loadNextPage() {
        guard hasNextPage && !isLoadingMore else { return }
        
        isLoadingMore = true
        
        Task {
            if selectedTab == .activity {
                await loadActivityNotifications(refresh: false)
            } else {
                await loadKeywordNotifications(refresh: false)
            }
            isLoadingMore = false
        }
    }
    
    /// 탭 변경 시 호출되는 메서드
    func selectTab(_ tab: NotificationType) {
        selectedTab = tab
        currentPage = 0
        hasNextPage = false
        isLoadingMore = false
        
        Task {
            await loadNotifications()
        }
    }
    
    private func loadActivityNotifications(refresh: Bool = true) async {
        if refresh {
            currentPage = 0
            isLoading = true
        }
        
        do {
            let response = try await notificationRepository.getActivityNotifications(
                page: currentPage,
                size: pageSize
            )
            
            if refresh {
                activityNotifications = response.result.content
            } else {
                activityNotifications.append(contentsOf: response.result.content)
            }
            
            hasNextPage = response.result.hasNext
            currentPage = response.result.page + 1
        } catch {
            print("NotificationViewModel Error: \(error)")
            errorMessage = "알림을 불러오는 중 오류가 발생했습니다."
        }
        
        isLoading = false
    }
    
    private func loadKeywordNotifications(refresh: Bool = true) async {
        if refresh {
            currentPage = 0
            isLoading = true
        }
        
        do {
            let response = try await notificationRepository.getKeywordNotifications(
                page: currentPage,
                size: pageSize
            )
            
            if refresh {
                keywordNotifications = response.result.content
            } else {
                keywordNotifications.append(contentsOf: response.result.content)
            }
            
            hasNextPage = response.result.hasNext
            currentPage = response.result.page + 1
        } catch {
            print("NotificationViewModel Error: \(error)")
            errorMessage = "알림을 불러오는 중 오류가 발생했습니다."
        }
        isLoading = false
    }
//
//    func markNotificationAsRead(notificationId: Int) async {
//        do {
//            let success = try await notificationRepository.markNotificationAsRead(notificationId: notificationId)
//            if success {
//                // 로컬에서 읽음 상태 업데이트
//                if let index = notifications.firstIndex(where: { $0.campaignStatusId == notificationId }) {
//                    notifications[index].isRead = true
//                }
//            }
//        } catch {
//            errorMessage = "알림 상태를 업데이트하는 중 오류가 발생했습니다: \(error.localizedDescription)"
//        }
//    }
    
    func refreshNotifications() async {
        if selectedTab == .activity {
            await loadActivityNotifications(refresh: true)
        } else {
            await loadKeywordNotifications(refresh: true)
        }
    }
}
