import Foundation

class CampaignRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    func getCampaignByCategory(
        regionGroup: [RegionGroup] = [],
        subRegion: [SubRegion] = [],
        local: [LocalCategory] = [],
        product: [ProductCategory] = [],
        reporter: ReporterType = .all,
        snsPlatform: [SocialPlatformType] = [],
        campaignPlatform: [CampaignPlatformType] = [],
        applyStart: String? = nil,
        applyEnd: String? = nil,
        sort: SortType = .popular,
        page: Int = 0,
        size: Int = 20
    ) async throws -> PageableResponse<CampaignDTO> {
        
        var queryParameters: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
            "size": "\(size)"
        ]
        
        // 배열 파라미터들 처리
        if !regionGroup.isEmpty {
            queryParameters["regionGroup"] = regionGroup.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !subRegion.isEmpty {
            queryParameters["subRegion"] = subRegion.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !local.isEmpty {
            queryParameters["local"] = local.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !product.isEmpty {
            queryParameters["product"] = product.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !snsPlatform.isEmpty {
            queryParameters["snsPlatform"] = snsPlatform.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !campaignPlatform.isEmpty {
            queryParameters["campaignPlatform"] = campaignPlatform.map { $0.rawValue }.joined(separator: ",")
        }
        
        // 단일 파라미터들 처리
        if reporter != .all {
            queryParameters["reporter"] = reporter.rawValue
        }
        
        if let applyStart = applyStart {
            queryParameters["applyStart"] = applyStart
        }
        
        if let applyEnd = applyEnd {
            queryParameters["applyEnd"] = applyEnd
        }
        
        do {
            let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(
                CampaignEndpoint.getCampaignByCategory,
                queryParameters: queryParameters
            )
            return response.result
        } catch {
            print("CampaignRepository getCampaignByCategory Error: \(error)")
            throw error
        }
    }
    
    func getCampaignByType(type: CampaignType, sortType: SortType) async throws -> PageableResponse<CampaignDTO> {
        let query: [String: String] = [
            "type": type.rawValue,
            "sort": sortType.rawValue,
            "page": "0",
            "size": "20"
        ]
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getCampaignByType, queryParameters: query)
        return response.result
    }
    
    func getCampaignBySNSPlatform(_ platform: SocialPlatformType, _ sortType: SortType) async throws -> PageableResponse<CampaignDTO> {
        let query: [String: String] = [
            "platform": platform.rawValue,
            "sort": "popular",
            "page": "0",
            "size": "5"
        ]
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getCampaignBySNSPlatform, queryParameters: query)
        return response.result
    }
    
    func getCampaignByCampaignPlatform(_ platform: CampaignPlatformType) async throws -> PageableResponse<CampaignDTO> {
        let query = [
            "platform": "all",
            "sort": "popular",
            "page": "0",
            "size": "5"
        ]
        
        do {
            let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(
                CampaignEndpoint.getCampaignByCampaignPlatform,
                queryParameters: query
            )
            return response.result
        } catch {
            print("CampaignRepository Error: \(error)")
            throw error
        }
    }
    
    func searchCampaignsByCategory(
        query: String? = nil,
        regionGroup: [RegionGroup] = [],
        subRegion: [SubRegion] = [],
        local: [LocalCategory] = [],
        product: [ProductCategory] = [],
        reporter: ReporterType = .all,
        snsPlatform: [SocialPlatformType] = [],
        campaignPlatform: [CampaignPlatformType] = [],
        applyStart: String? = nil,
        applyEnd: String? = nil,
        sort: SortType = .popular,
        page: Int = 0,
        size: Int = 20
    ) async throws -> PageableResponse<CampaignDTO> {
        
        var queryParameters: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
            "size": "\(size)"
        ]
        
        // 검색어
        if let query = query, !query.isEmpty {
            queryParameters["query"] = query
        }
        
        // 배열 파라미터들 처리
        if !regionGroup.isEmpty {
            queryParameters["regionGroup"] = regionGroup.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !subRegion.isEmpty {
            queryParameters["subRegion"] = subRegion.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !local.isEmpty {
            queryParameters["local"] = local.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !product.isEmpty {
            queryParameters["product"] = product.map { $0.rawValue }.joined(separator: ",")
        }
        
        if !snsPlatform.isEmpty {
            queryParameters["snsPlatform"] = snsPlatform.map { $0.imageName }.joined(separator: ",")
        }
        
        if !campaignPlatform.isEmpty {
            queryParameters["campaignPlatform"] = campaignPlatform.map { $0.imageName }.joined(separator: ",")
        }
        
        // 단일 파라미터들 처리
        if reporter != .all {
            queryParameters["reporter"] = reporter.rawValue
        }
        
        if let applyStart = applyStart {
            queryParameters["applyStart"] = applyStart
        }
        
        if let applyEnd = applyEnd {
            queryParameters["applyEnd"] = applyEnd
        }
        
        do {
            let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(
                CampaignEndpoint.getCampaignByCategory,
                queryParameters: queryParameters
            )
            return response.result
        } catch {
            print("CampaignRepository Enhanced Search Error: \(error)")
            throw error
        }
    }
    
    func getMyCampaignsByStatus() async throws -> APIResponse<MyCampaignsResponse>  {
        return try await networkAPI.request(CampaignEndpoint.getMyCampaignByStatus)
    }
}
