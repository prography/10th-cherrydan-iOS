import Foundation
import SwiftUI

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var activityNotifications: [ActivityNotification] = []
    @Published var keywordNotifications: [KeywordNotification] = []
    @Published var keywordCount: Int = 0
    @Published var selectedTab: NotificationType = .activity
    @Published var selectedNotifications: Set<Int> = []
    
    @Published var isLoading: Bool = false
    @Published var hasNextPage: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private let notificationRepository: NotificationRepository
    private let keywordRepository: KeywordRepository
    private var currentPage: Int = 0
    private let pageSize: Int = 20
    
    init(
        notificationRepository: NotificationRepository = NotificationRepository(),
        keywordRepository: KeywordRepository = KeywordRepository()
    ) {
        self.notificationRepository = notificationRepository
        self.keywordRepository = keywordRepository
        loadNotifications()
    }
    
    func loadNotifications() {
        if selectedTab == .activity {
            loadActivityNotifications(refresh: true)
        } else {
            loadUserKeywordCount()
            loadKeywordNotifications(refresh: true)
        }
    }
    
    /// 인피니트 스크롤을 위한 다음 페이지 로드
    func loadNextPage() {
        guard hasNextPage && !isLoadingMore else { return }
        
        Task {
            isLoadingMore = true
            if selectedTab == .activity {
                loadActivityNotifications(refresh: false)
            } else {
                loadKeywordNotifications(refresh: false)
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
        
        clearSelection()
        loadNotifications()
    }
    
    private func loadActivityNotifications(refresh: Bool = true) {
        Task {
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
                ToastManager.shared.show(.errorWithMessage("알림을 불러오는 중 오류가 발생했습니다."))
            }
            isLoading = false
        }
    }
    
    private func loadKeywordNotifications(refresh: Bool = true) {
        Task {
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
                ToastManager.shared.show(.errorWithMessage("알림을 불러오는 중 오류가 발생했습니다."))
            }
             
            isLoading = false
        }
    }
    
    private func loadUserKeywordCount() {
        Task {
            do {
                isLoading = true
                let response = try await keywordRepository.getUserKeywords()
                keywordCount = response.result.count
            } catch {
                ToastManager.shared.show(.errorWithMessage("키워드 목록을 불러오는 중 오류가 발생했습니다."))
            }
            isLoading = false
        }
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

    // MARK: - Selection Helpers
    func isSelected(_ id: Int) -> Bool {
        selectedNotifications.contains(id)
    }
    
    func toggleSelect(_ id: Int) {
        if selectedNotifications.contains(id) {
            selectedNotifications.remove(id)
        } else {
            selectedNotifications.insert(id)
        }
    }
    
    func selectAll(_ ids: [Int]) {
        selectedNotifications = Set(ids)
    }
    
    func deselectAll(_ ids: [Int]) {
        for id in ids {
            selectedNotifications.remove(id)
        }
    }
    
    func clearSelection() {
        selectedNotifications.removeAll()
    }
}
