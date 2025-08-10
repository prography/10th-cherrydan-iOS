import Foundation

class KeywordRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    // MARK: - User Keywords
    
    /// 내 키워드 목록 조회
    func getUserKeywords(page: Int = 0, size: Int = 20) async throws -> APIResponse<[UserKeywordResponseDTO]> {
        let query: [String: String] = [
            "page": String(page),
            "size": String(size)
        ]
        
        return try await networkAPI.request(
            KeywordEndpoint.getUserKeywords,
            queryParameters: query
        )
    }
    
    /// 내 키워드 등록
    func addUserKeyword(keyword: String) async throws {
        let query: [String: String] = [
            "keyword": keyword
        ]
        
        let _: EmptyResult = try await networkAPI.request(
            KeywordEndpoint.addUserKeyword(keyword: keyword),
        parameters: query
        )
    }
    
    /// 내 키워드 삭제
    func deleteUserKeyword(keywordId: Int) async throws {
        let _: EmptyResult = try await networkAPI.request(
            KeywordEndpoint.deleteUserKeyword(keywordId: keywordId)
        )
    }
    
    // MARK: - Keyword Alerts
    
    /// 내 키워드 알림 목록 조회
    func getKeywordNotifications(page: Int = 0) async throws -> APIResponse<PageableResponse<KeywordNotification>> {
        let query: [String: String] = [
            "page": String(page),
            "size": "20",
            "sort": "alertDate,desc"
        ]
        
        return try await networkAPI.request(
            KeywordEndpoint.getKeywordAlerts,
            queryParameters: query
        )
    }
    
    /// 키워드 알림 삭제
    func deleteKeywordAlerts(alertIds: [Int]) async throws {
        let params = ["alertIds": alertIds]
        let _: EmptyResult = try await networkAPI.request(
            KeywordEndpoint.deleteKeywordAlerts,
            parameters: params
        )
    }
    
    // 키워드 알림 읽음 처리
    func markKeywordAlertsAsRead(alertIds: [Int]) async throws {
        let params = ["alertIds": alertIds]
        let _: EmptyResult = try await networkAPI.request(
            KeywordEndpoint.markKeywordAlertsAsRead,
            parameters: params
        )
    }
    
    // MARK: - Personalized Campaigns
    
    /// 특정 키워드로 맞춤형 캠페인 조회
    func getPersonalizedCampaignsByKeyword(
        keyword: String,
        date: String,
        page: Int = 0
    ) async throws -> APIResponse<PageableResponse<CampaignDTO>> {
        let query: [String: String] = [
            "page": String(page),
            "date": date,
            "size": "20",
            "keyword": keyword
        ]
        
        return try await networkAPI.request(
            KeywordEndpoint.getPersonalizedCampaignsByKeyword(keyword: keyword),
            queryParameters: query
        )
    }
}
