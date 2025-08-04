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
    
    func loadMoreNotifications() async {
        await loadActivityNotifications(refresh: false)
    }
    
    private func loadActivityNotifications(refresh: Bool = true) async {
        if refresh {
            currentPage = 0
        }
        
        
        do {
            isLoading = true
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
        }
        
        isLoading = false
    }
    
    private func loadKeywordNotifications(refresh: Bool = true) async {
        if refresh {
            currentPage = 0
        }
        
        
        do {
            isLoading = true
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
        await loadActivityNotifications(refresh: true)
    }
}
