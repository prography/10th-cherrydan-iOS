import Foundation
import SwiftUI

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var activityNotifications: [ActivityNotification] = []
    @Published var keywordNotifications: [KeywordNotification] = []
    @Published var keywordCount: Int = 0
    @Published var selectedTab: NotificationType = .activity
    @Published var isDeleteMode: Bool = false
    @Published var selectedNotifications: Set<Int> = []
    
    @Published var isLoading: Bool = false
    @Published var hasNextPage: Bool = false
    @Published var isLoadingMore: Bool = false
    
    private let activityRepository: ActivityRepository
    private let keywordRepository: KeywordRepository
    private var currentPage: Int = 0
    
    init(
        initialSelectedTab: NotificationType = .activity,
        activityRepository: ActivityRepository = ActivityRepository(),
        keywordRepository: KeywordRepository = KeywordRepository()
    ) {
        self.activityRepository = activityRepository
        self.keywordRepository = keywordRepository
        self.selectedTab = initialSelectedTab
        
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
                let response = try await activityRepository.getActivityNotifications(
                    page: currentPage
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
                let response = try await keywordRepository.getKeywordNotifications(
                    page: currentPage
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
    
    // MARK: - Selection scope helpers
    private var currentIds: [Int] {
        if selectedTab == .activity {
            return activityNotifications.map { $0.id }
        } else {
            return keywordNotifications.map { $0.id }
        }
    }
    
    private var selectedIdsInCurrentTab: [Int] {
        let currentIdSet = Set(currentIds)
        return selectedNotifications.filter { currentIdSet.contains($0) }
    }
    
    
    // MARK: - Bulk actions
    func deleteSelectedAlerts() {
        let ids = selectedIdsInCurrentTab
        guard !ids.isEmpty else { return }
        
        Task {
            do {
                if selectedTab == .activity {
                    try await activityRepository.deleteActivityAlerts(alertIds: selectedIdsInCurrentTab)
                    activityNotifications.removeAll { ids.contains($0.id) }
                } else {
                    try await keywordRepository.deleteKeywordAlerts(alertIds: selectedIdsInCurrentTab)
                    keywordNotifications.removeAll { ids.contains($0.id) }
                }
                clearSelection()
                isDeleteMode = false
            } catch {
                ToastManager.shared.show(.errorWithMessage("알림 삭제 중 오류가 발생했습니다."))
            }
        }
    }
    
    func markSelectedAlertsAsRead() {
        let ids = selectedIdsInCurrentTab
        guard !ids.isEmpty else { return }
        
        Task {
            do {
                isLoading = true
                if selectedTab == .activity {
                    try await activityRepository.markActivityAlertsAsRead(alertIds: selectedIdsInCurrentTab)
                    activityNotifications = activityNotifications.map { item in
                        if ids.contains(item.id) {
                            return ActivityNotification(
                                id: item.id,
                                campaignId: item.campaignId,
                                campaignTitle: item.campaignTitle,
                                applyEndDate: item.applyEndDate,
                                alertDate: item.alertDate,
                                isRead: true,
                                dday: item.dday
                            )
                        }
                        return item
                    }
                } else {
                    try await keywordRepository.markKeywordAlertsAsRead(alertIds: selectedIdsInCurrentTab)
                    keywordNotifications = keywordNotifications.map { item in
                        if ids.contains(item.id) {
                            return KeywordNotification(
                                id: item.id,
                                keyword: item.keyword,
                                alertDate: item.alertDate,
                                campaignCount: item.campaignCount,
                                isRead: true
                            )
                        }
                        return item
                    }
                }
                
                clearSelection()
                isLoading = false
            } catch {
                ToastManager.shared.show(.errorWithMessage("알림 읽음 처리 중 오류가 발생했습니다."))
            }
        }
    }

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
