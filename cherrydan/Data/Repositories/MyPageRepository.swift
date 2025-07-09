import Foundation

class MyPageRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func getVersion() async throws -> String {
        let response: APIResponse<VersionResult> = try await networkAPI.request(MyPageEndpoint.getVersion)
        
        return response.result.version
    }
}
