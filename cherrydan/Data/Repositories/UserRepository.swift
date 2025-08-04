import Foundation

class UserRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func deleteUser() async throws -> Bool {
        let response: APIResponse<EmptyResult> = try await networkAPI.request(UserEndpoint.deleteUser)
        return response.code == 200
    }
    
    func getUser() async throws -> APIResponse<UserDTO> {
        return try await networkAPI.request(UserEndpoint.getUser)
    }
}
