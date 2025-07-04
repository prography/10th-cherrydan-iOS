import Foundation

class NotificationRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    // MARK: - Activity Notifications
    
    func getActivityNotifications(page: Int = 0, size: Int = 20) async throws ->APIResponse<PageableResponse<ActivityNotification>> {
        let query:[String:String] = [
            "page": String(page),
            "size": String(size),
            "sort": "activityNotifiedAt,asc"
        ]
        
        do {
            return try await networkAPI.request(.getActivityNotification, queryParameters: query)
        } catch {
            print("NotificationRepository Error: \(error)")
            throw error
        }
    }
    
    func getKeywordNotifications(page: Int = 0, size: Int = 20) async throws ->APIResponse<PageableResponse<KeywordNotification>> {
        let query:[String:String] = [
            "page": String(page),
            "size": String(size),
            "sort": "alertDate,asc"
        ]
        
        do {
            return try await networkAPI.request(.getKeywordNotification, queryParameters: query)
        } catch {
            print("NotificationRepository Error: \(error)")
            throw error
        }
    }
}

// MARK: - Response Models
