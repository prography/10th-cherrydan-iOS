import Foundation
import UIKit

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
    
    func putFcmToken(fcmToken: String, isAllowed: Bool) async throws -> Bool {
        let deviceModel = await UIDevice.current.modelName
        let response: APIResponse<[FcmTokensDTO]> = try await networkAPI.request(UserEndpoint.getFcmTokens)
        let deviceId = response.result.first { $0.deviceType == "IOS" && $0.deviceModel == deviceModel }?.deviceId ?? -1
        
        let params: [String : Any] = [
            "deviceId": deviceId,
            "fcmToken": fcmToken,
            "isAllowed": isAllowed
        ]
        
        let res: APIResponse<EmptyResult> = try await networkAPI.request(UserEndpoint.patchFcmToken, parameters: params)
        return res.code == 200
    }
}
