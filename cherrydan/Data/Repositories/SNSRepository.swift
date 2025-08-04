import Foundation

class SNSRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    /// 네이버 블로그 인증 및 연동
    func verifyNaverBlog(blogUrl: String) async throws -> NaverVerifyResponseDTO {
        let parameters = [
            "blog_url": blogUrl
        ]
        let response: APIResponse<NaverVerifyResponseDTO> = try await networkAPI.request(
            SNSEndpoint.naverVerify,
            parameters: parameters
        )
        return response.result
    }
    
    /// OAuth 인증 URL 생성
    func getOAuthAuthUrl(platform: String) async throws -> OAuthAuthUrlResponseDTO {
        let response: APIResponse<OAuthAuthUrlResponseDTO> = try await networkAPI.request(
            SNSEndpoint.oauthAuthUrl(platform: platform)
        )
        return response.result
    }
    
    /// OAuth 콜백 처리
    func handleOAuthCallback(platform: String, code: String, state: String? = nil) async throws -> OAuthCallbackResponseDTO {
        var queryParameters: [String: String] = [
            "code": code
        ]
        
        if let state = state {
            queryParameters["state"] = state
        }
        
        let response: APIResponse<OAuthCallbackResponseDTO> = try await networkAPI.request(
            SNSEndpoint.oauthCallback(platform: platform),
            queryParameters: queryParameters
        )
        return response.result
    }
    
    /// 사용자 SNS 연동 목록 조회
    func getConnections() async throws -> SNSConnectionsResponseDTO {
        let response: APIResponse<SNSConnectionsResponseDTO> = try await networkAPI.request(
            SNSEndpoint.getConnections
        )
        return response.result
    }
    
    /// 사용자 SNS 연동 목록 조회 (도메인 엔티티로 변환)
    func getSNSConnections() async throws -> [SNSConnection] {
        let response = try await getConnections()
        return response.connections.map { $0.toSNSConnection() }
    }
    
    /// SNS 연동 해제
    func disconnect(platform: String) async throws -> Bool {
        let response: APIResponse<EmptyResult> = try await networkAPI.request(
            SNSEndpoint.disconnect(platform: platform)
        )
        return response.code == 200
    }
    
    // MARK: - SocialPlatformType 기반 편의 메서드들
    
    /// OAuth 인증 URL 생성 (SocialPlatformType 기반)
    func getOAuthAuthUrl(for platformType: SocialPlatformType) async throws -> OAuthAuthUrlResponseDTO {
        return try await getOAuthAuthUrl(platform: platformType.apiPlatformKey)
    }
    
    /// OAuth 콜백 처리 (SocialPlatformType 기반)
    func handleOAuthCallback(for platformType: SocialPlatformType, code: String, state: String? = nil) async throws -> OAuthCallbackResponseDTO {
        return try await handleOAuthCallback(platform: platformType.apiPlatformKey, code: code, state: state)
    }
    
    /// SNS 연동 해제 (SocialPlatformType 기반)
    func disconnect(platformType: SocialPlatformType) async throws -> Bool {
        return try await disconnect(platform: platformType.apiPlatformKey)
    }
} 