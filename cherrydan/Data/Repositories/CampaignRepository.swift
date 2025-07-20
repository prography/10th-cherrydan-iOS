import Foundation

class CampaignRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    /// - Note: SearchView에서 호출합니다.
    func getCampaignByCategory(
        regionGroup: [RegionGroup] = [],
        subRegion: [SubRegion] = [],
        local: [LocalCategory] = [],
        product: [ProductCategory] = [],
        reporter: [ReporterType] = [],
        snsPlatform: [SocialPlatformType] = [],
        campaignPlatform: [CampaignPlatformType] = [],
        sort: SortType = .popular,
        page: Int = 0,
        size: Int = 20
    ) async throws -> PageableResponse<CampaignDTO> {
        
        var queryParameters: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
            "size": "\(size)"
        ]
        
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
        
        if !reporter.isEmpty {
            queryParameters["reporter"] = campaignPlatform.map { $0.rawValue }.joined(separator: ",")
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
    
    /// - Note: HomeView 내부 `전체`, `지역`, `제품` 탭에서 호출합니다.
    func getCampaignByType(
        _ type: CampaignType,
        sort: SortType = .popular,
        page: Int = 0,
        size: Int = 20
    ) async throws -> PageableResponse<CampaignDTO> {
        guard type == .all || type == .product || type == .region else {  throw APIError.notFound }
        
        var queryParameters: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
            "size": "\(size)"
        ]
        switch type {
        case .all:
            break
        case .region:
            if !regionGroups.isEmpty {
                queryParameters["regionGroup"] = regionGroups.map {
                    $0.rawValue
                }.joined(separator: ",")
            }
            
            if !subRegions.isEmpty {
                queryParameters["subRegion"] = subRegions.map {
                    $0.rawValue
                }.joined(separator: ",")
            }
        case .product:
        }
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getCampaignByType, queryParameters: queryParameters)
        return response.result
    }
    
    /// - Note: HomeView 내부 `SNS 플랫폼` 탭에서 호출합니다.
    func getCampaignBySNSPlatform(
        _ snsPlatform: [SocialPlatformType] = [],
        sort: SortType = .popular,
        page: Int = 0,
        size: Int = 20
    ) async throws -> PageableResponse<CampaignDTO> {
        var queryParameters: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
            "size": "\(size)"
        ]
        
        if !snsPlatform.isEmpty {
            queryParameters["snsPlatform"] = snsPlatform.map { $0.imageName }.joined(separator: ",")
        } else {
            queryParameters["snsPlatform"] = "all"
        }
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getCampaignBySNSPlatform, queryParameters: queryParameters)
        return response.result
    }
    
    /// - Note: HomeView 내부 `캠페인 플랫폼` 탭에서 호출합니다.
    func getCampaignByCampaignPlatform(
        _ campaignPlatform: [CampaignPlatformType] = [],
        sort: SortType = .popular,
        page: Int = 0,
        size: Int = 20
    ) async throws -> PageableResponse<CampaignDTO> {
        var queryParameters: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
            "size": "\(size)"
        ]
        
        if !campaignPlatform.isEmpty {
            queryParameters["campaignPlatform"] = campaignPlatform.map { $0.imageName }.joined(separator: ",")
        } else {
            queryParameters["campaignPlatform"] = "all"
        }
        
        do {
            let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(
                CampaignEndpoint.getCampaignByCampaignPlatform,
                queryParameters: queryParameters
            )
            return response.result
        } catch {
            print("CampaignRepository Error: \(error)")
            throw error
        }
    }
    
    func searchCampaigns(_ keyword: String) async throws -> [CampaignDTO] {
        let query = ["keyword": keyword]
        
        do {
            let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(
                CampaignEndpoint.getCampaign,
                queryParameters: query
            )
            
            return response.result.content
        } catch {
            print("CampaignRepository Error: \(error)")
            throw error
        }
    }
    
    func searchCampaignsByCategory(
        query: String? = nil,
        regionGroups: [RegionGroup] = [],
        subRegions: [SubRegion] = [],
        local: [LocalCategory] = [],
        product: [ProductCategory] = [],
        snsPlatform: [SocialPlatformType] = [],
        campaignPlatform: [CampaignPlatformType] = [],
        sort: SortType = .popular,
        page: Int = 0,
        size: Int = 20,
        focusedCategory: CampaignType? = nil,
        isReporter: Bool = false
    ) async throws -> PageableResponse<CampaignDTO> {
        var queryParameters: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
            "size": "\(size)"
        ]
        
        if let query = query, !query.isEmpty {
            queryParameters["title"] = query
        }
        
        if !regionGroups.isEmpty {
            queryParameters["regionGroup"] = regionGroups.map {
                $0.rawValue
            }.joined(separator: ",")
        }
        
        if !subRegions.isEmpty {
            queryParameters["subRegion"] = subRegions.map {
                $0.rawValue
            }.joined(separator: ",")
        }
        
        switch focusedCategory {
        case .region:
            if !local.isEmpty {
                queryParameters["local"] = local.map { $0.rawValue }.joined(separator: ",")
            } else {
                queryParameters["local"] = "all"
            }
        case .product:
            if !product.isEmpty {
                queryParameters["product"] = product.map { $0.rawValue }.joined(separator: ",")
            } else {
                queryParameters["product"] = "all"
            }
        case .snsPlatform:
            if !snsPlatform.isEmpty {
                queryParameters["snsPlatform"] = snsPlatform.map { $0.imageName }.joined(separator: ",")
            } else {
                queryParameters["snsPlatform"] = "all"
            }
        case .campaignPlatform:
            if !campaignPlatform.isEmpty {
                queryParameters["campaignPlatform"] = campaignPlatform.map { $0.imageName }.joined(separator: ",")
            } else {
                queryParameters["campaignPlatform"] = "all"
            }
        default:
            if !local.isEmpty {
                queryParameters["local"] = local.map { $0.rawValue }.joined(separator: ",")
            } else {
                queryParameters["local"] = "all"
            }
            if !product.isEmpty {
                queryParameters["product"] = product.map { $0.rawValue }.joined(separator: ",")
            } else {
                queryParameters["product"] = "all"
            }
            if !snsPlatform.isEmpty {
                queryParameters["snsPlatform"] = snsPlatform.map { $0.imageName }.joined(separator: ",")
            } else {
                queryParameters["snsPlatform"] = "all"
            }
            if !campaignPlatform.isEmpty {
                queryParameters["campaignPlatform"] = campaignPlatform.map { $0.imageName }.joined(separator: ",")
            } else {
                queryParameters["campaignPlatform"] = "all"
            }
        }
        
        if isReporter {
            queryParameters["reporter"] = "all"
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
