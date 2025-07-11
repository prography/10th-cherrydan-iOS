import Foundation

class NetworkAPI {
    private let session = URLSession.shared
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        parameters: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> T {
        guard NetworkManager.shared.isConnected else {
            throw APIError.networkError
        }
        
        var urlString = APIConstants.baseUrl + endpoint.path
        
        if let queryParams = queryParameters, !queryParams.isEmpty {
            var components = URLComponents(string: urlString)
            components?.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
            urlString = components?.url?.absoluteString ?? urlString
        }
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch endpoint.tokenType {
        case .none:
            break
        case .accessToken:
            guard let token = KeychainManager.shared.getAccessToken() else {
                throw APIError.unauthorized
            }
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        case .refreshToken:
            guard let token = KeychainManager.shared.getRefreshToken() else {
                throw APIError.unauthorized
            }
            
            request.setValue("\(token)", forHTTPHeaderField: "x-refresh-token")
        }
        
        // GET 요청이 아닌 경우에만 body에 parameters 추가
        if endpoint.method != .get, let parameters = parameters {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            if APIConstants.isServerDevelopment {
                print("🛜 API Request: \(endpoint.method.rawValue) - \(urlString)")
                if let params = parameters {
                    print("Body Parameters: \(params)")
                }
                if let queryParams = queryParameters, !queryParams.isEmpty {
                    print("Query Parameters: \(queryParams)")
                }
                print("▶️ Response: \(String(data: data, encoding: .utf8) ?? "Unable to decode response")")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.notFound
            }
            
            // 성공적인 응답인지 확인 (200-299 상태 코드)
            guard (200...299).contains(httpResponse.statusCode) else {
                // 서버에서 에러 응답을 보낸 경우, 응답 메시지를 파싱 시도
                if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = errorResponse["message"] as? String {
                    throw APIError.from(statusCode: httpResponse.statusCode, message: message)
                } else {
                    throw APIError.from(statusCode: httpResponse.statusCode)
                }
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            if let apiError = error as? APIError {
                if apiError.isAutoHandled {
                    /// - Note: 로그인 상황에서 401에러는 계정정보 불일치이므로, 뷰모델로 전파가 필요합니다.
                    
                    handleError(apiError)
                } else {
                    throw apiError
                }
            }
            throw APIError(error: error)
        }
    }
    
    private func handleError(_ error: APIError) {
        DispatchQueue.main.async {
            switch error {
            case .unauthorized:
                AuthManager.shared.logout()
            default:
                print(error.localizedDescription)
//                ToastManager.shared.show(.error(error.localizedDescription))
            }
        }
    }
}
