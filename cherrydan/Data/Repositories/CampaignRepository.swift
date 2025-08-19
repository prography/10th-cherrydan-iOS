import Foundation

class CampaignRepository {
    private let networkAPI: NetworkAPI
    
    init(networkAPI: NetworkAPI = NetworkAPI()) {
        self.networkAPI = networkAPI
    }
    
    /// - Note: HomeView 내부 `전체`, 탭에서 호출합니다.
    func getAllCampaign(
        sort: SortType = .popular,
        page: Int = 0,
    ) async throws -> PageableResponse<CampaignDTO> {
        let query: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
        ]
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getAllCampaign, queryParameters: query)
        return response.result
    }
    
    /// - Note: HomeView 내부 `지역` 탭에서 호출합니다.
    func getCampaignByRegion(
        regionGroups: [RegionGroup] = [],
        subRegions: [SubRegion] = [],
        local: [LocalCategory] = [],
        sort: SortType = .popular,
        page: Int = 0,
    ) async throws -> PageableResponse<CampaignDTO> {
        var query: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
        ]
        
        if !regionGroups.isEmpty {
            query["regionGroup"] = regionGroups.map {
                $0.rawValue
            }.joined(separator: ",")
        }
        
        if !subRegions.isEmpty {
            query["subRegion"] = subRegions.map {
                $0.rawValue
            }.joined(separator: ",")
        }
        
        if !local.isEmpty {
            query["localCategory"] = local.map { $0.rawValue }.joined(separator: ",")
        } else {
            query["localCategory"] = "all"
        }
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getCampaignByRegion, queryParameters: query)
        return response.result
    }
    
    func getCampaignByReporter(
        sort: SortType = .popular,
        page: Int = 0
    ) async throws -> PageableResponse<CampaignDTO> {
        do {
            let query: [String: String] = [
                "sort": sort.rawValue,
                "page": "\(page)",
            ]
            
            let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getCampaignByReporter, queryParameters: query)
            return response.result
        } catch {
            print("CampaignRepository Error: \(error)")
            throw error
        }
    }
    
    
    /// - Note: HomeView 내부 `제품` 탭에서 호출합니다.
    func getCampaignByProduct(
        _ product: [ProductCategory] = [],
        sort: SortType = .popular,
        page: Int = 0,
    ) async throws -> PageableResponse<CampaignDTO> {
        var query: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)"
        ]
        
        if !product.isEmpty {
            query["productCategory"] = product.map { $0.rawValue }.joined(separator: ",")
        } else {
            query["productCategory"] = "all"
        }
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getCampaignByProduct, queryParameters: query)
        return response.result
    }
    
    /// - Note: HomeView 내부 `SNS 플랫폼` 탭에서 호출합니다.
    func getCampaignBySNSPlatform(
        _ snsPlatform: [SNSPlatformType] = [],
        sort: SortType = .popular,
        page: Int = 0
    ) async throws -> PageableResponse<CampaignDTO> {
        var query: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)"
        ]
        
        if !snsPlatform.isEmpty {
            query["platform"] = snsPlatform.map { $0.apiValue }.joined(separator: ",")
        } else {
            query["platform"] = "all"
        }
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.getCampaignBySNSPlatform, queryParameters: query)
        return response.result
    }
    
    /// - Note: HomeView 내부 `캠페인 플랫폼` 탭에서 호출합니다.
    func getCampaignByCampaignPlatform(
        _ campaignPlatform: [CampaignPlatform] = [],
        sort: SortType = .popular,
        page: Int = 0
    ) async throws -> PageableResponse<CampaignDTO> {
        var query: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)"
        ]
        
        if !campaignPlatform.isEmpty {
            query["platform"] = campaignPlatform.map { $0.siteNameEn }.joined(separator: ",")
        } else {
            query["platform"] = "all"
        }
        
        let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(
            CampaignEndpoint.getCampaignByCampaignPlatform, queryParameters: query)
        return response.result
    }
    
    /// - Note: SearchView 내부 `검색 단계`에서 호출합니다.
    func getCampaignSites() async throws -> [CampaignPlatform] {
        do {
            let response: APIResponse<[CampaignPlatform]> = try await networkAPI.request(CampaignEndpoint.getCampaignSites)
            
            return response.result
        } catch {
            print("CampaignRepository Error: \(error)")
            throw error
        }
    }
    
    /// - Note: SearchView 내부 `검색 단계`에서 호출합니다.
    func searchCampaign(_ keyword: String) async throws -> [CampaignDTO] {
        let query = ["keyword": keyword]
        
        do {
            let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(CampaignEndpoint.searchCampaign, queryParameters: query)
            
            return response.result.content
        } catch {
            print("CampaignRepository Error: \(error)")
            throw error
        }
    }
    
    /// - Note: SearchView 내부 `사이드메뉴 통한 상세 필터링`에서 호출합니다.
    func searchCampaignsByCategory(
        query: String? = nil,
        regionGroups: [RegionGroup] = [],
        subRegions: [SubRegion] = [],
        local: [LocalCategory] = [],
        product: [ProductCategory] = [],
        snsPlatform: [SNSPlatformType] = [],
        campaignPlatform: [CampaignPlatform] = [],
        applyStart: String? = nil,
        applyEnd: String? = nil,
        sort: SortType = .popular,
        page: Int = 0,
        isReporter: Bool = false
    ) async throws -> PageableResponse<CampaignDTO> {
        var queryParameters: [String: String] = [
            "sort": sort.rawValue,
            "page": "\(page)",
            "size": "20"
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
            queryParameters["campaignPlatform"] = campaignPlatform.map { $0.siteNameEn }.joined(separator: ",")
        } else {
            queryParameters["campaignPlatform"] = "all"
        }
        
        if !local.isEmpty {
            queryParameters["local"] = local.map { $0.rawValue }.joined(separator: ",")
        } else {
            queryParameters["local"] = "all"
        }
        
        if let applyStart {
            queryParameters["applyStart"] = applyStart
        }
        
        if let applyEnd {
            queryParameters["applyEnd"] = applyEnd
        }
        
        if isReporter {
            queryParameters["reporter"] = "all"
        }
        
        do {
            let response: APIResponse<PageableResponse<CampaignDTO>> = try await networkAPI.request(
                CampaignEndpoint.searchCampaignByCategory,
                queryParameters: queryParameters
            )
            return response.result
        } catch {
            print("CampaignRepository Enhanced Search Error: \(error)")
            throw error
        }
    }
}
