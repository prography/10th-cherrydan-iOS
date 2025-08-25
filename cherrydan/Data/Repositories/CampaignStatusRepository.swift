import Foundation

class CampaignStatusRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func getMyCampaings(for status: CampaignStatusType, page: Int = 0) async throws -> PageableResponse<MyCampaignDTO> {
        let query: [String:String] = [
            "status": status.apiValue,
            "page": String(page),
            "size": "20"
        ]
        let response: APIResponse<PageableResponse<MyCampaignDTO>> = try await networkAPI.request(CampaignStatusEndpoint.getMyCampaigns, queryParameters: query)
        return response.result
    }
    
    func createOrRecoverStatus(request: CampaignStatusRequestDTO) async throws -> MyCampaignDTO {
    
        
        let response: APIResponse<MyCampaignDTO> = try await networkAPI.request(CampaignStatusEndpoint.createOrRecoverStatus, parameters: request.dictionaryFormat)
        return response.result
    }
    
    func updateStatus(request: CampaignStatusRequestDTO) async throws -> MyCampaignDTO {
        let response: APIResponse<MyCampaignDTO> = try await networkAPI.request(CampaignStatusEndpoint.updateStatus, parameters: request.dictionaryFormat)
        return response.result
    }
    
    func deleteStatus(request: DeleteRequest) async throws -> Void {
        let _: APIResponse<EmptyResult> = try await networkAPI.request(CampaignStatusEndpoint.deleteStatus, parameters: request.dictionaryFormat)
    }
    
    func getPopupStatus() async throws -> CampaignStatusPopupResponseDTO {
        let response: APIResponse<CampaignStatusPopupResponseDTO> = try await networkAPI.request(CampaignStatusEndpoint.getPopupStatus)
        return response.result
    }
}
