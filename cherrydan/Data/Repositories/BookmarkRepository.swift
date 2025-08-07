import Foundation

class BookmarkRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    /// 북마크 추가
    func addBookmark(campaignId: Int) async throws {
        let _: EmptyResult = try await networkAPI.request(
            BookmarkEndpoint.addBookmark(campaignId: campaignId)
        )
    }
    
    /// 북마크 취소 (is_active = false)
    func cancelBookmark(campaignId: Int) async throws {
        let _: EmptyResult = try await networkAPI.request(
            BookmarkEndpoint.cancelBookmark(campaignId: campaignId)
        )
    }
    
    /// 북마크 완전 삭제
    func deleteBookmark(campaignId: Int) async throws {
        let _: EmptyResult = try await networkAPI.request(
            BookmarkEndpoint.deleteBookmark(campaignId: campaignId)
        )
    }
    
    /// 내 북마크 목록 조회
    func getBookmarks(page: Int = 0, size: Int = 20) async throws -> BookmarkListResponseDTO {
        let query = [
            "page": "\(page)",
            "size": "\(size)"
        ]
        
        let response: APIResponse<BookmarkListResponseDTO> = try await networkAPI.request(
            BookmarkEndpoint.getBookmarks,
            queryParameters: query
        )
        return response.result
    }
}
