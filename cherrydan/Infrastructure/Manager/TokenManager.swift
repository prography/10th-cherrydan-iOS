import Foundation

actor TokenManager {
    static let shared = TokenManager()
    private var currentRefreshTask: Task<Bool, Never>?
    
    private init() {}
    
    func ensureValidToken() async -> Bool {
        // 이미 진행 중인 갱신 작업이 있다면 그 결과를 기다림
        if let ongoingTask = currentRefreshTask {
            let result = await ongoingTask.value
            debugPrint("🔄 [TokenManager] 대기 중이던 토큰 갱신 결과: \(result)")
            return result
        }
        
        debugPrint("🔄 [TokenManager] 새로운 토큰 갱신 작업 시작 (단일 실행 보장됨)")
        let refreshTask = Task<Bool, Never> {
            await performTokenRefresh()
        }
        
        currentRefreshTask = refreshTask
        
        let result = await refreshTask.value
        
        currentRefreshTask = nil
        
        debugPrint("🔄 [TokenManager] 토큰 갱신 작업 완료: \(result)")
        return result
    }
    
    private func performTokenRefresh() async -> Bool {
        guard let refreshToken = KeychainManager.shared.getRefreshToken(),
              !refreshToken.isEmpty else {
            debugPrint("🔴 [TokenManager] RefreshToken이 없어서 토큰 갱신 불가")
            return false
        }
        
        do {
            debugPrint("🔄 [TokenManager] 토큰 갱신 API 호출 시작...")
            try await performDirectTokenRefreshRequest()
            
            debugPrint("✅ [TokenManager] 토큰 갱신 API 호출 성공")
            return true
        } catch {
            debugPrint("🔴 [TokenManager] 토큰 갱신 실패: \(error)")
            // 갱신 실패 시 안전한 토큰 정리
            return false
        }
    }
    
    private func performDirectTokenRefreshRequest() async throws {
        guard NetworkManager.shared.isConnected else {
            throw APIError.networkError
        }
        
        guard let url = URL(string: NetworkConstants.baseUrl + "/auth/refresh") else {
            throw APIError.invalidURL
        }
        
        guard let token = KeychainManager.shared.getRefreshToken() else {
            throw APIError.unauthorized
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: ["refreshToken": token])
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
    
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.notFound
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.unauthorized
        }
        
        let decodedResponse = try JSONDecoder().decode(APIResponse<LoginResult>.self, from: data)
        
        KeychainManager.shared.saveTokens(
            decodedResponse.result.accessToken,
            decodedResponse.result.refreshToken
        )
    }
}
