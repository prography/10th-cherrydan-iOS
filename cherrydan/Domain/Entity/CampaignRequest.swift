import Foundation

enum CampaignRequestType: String, CaseIterable, Codable {
    case selectionRequest = "선정확인 요청"
    case registrationRequest = "등록확인 요청"
    case terminationRequest = "종료확인 요청"
}

struct CampaignRequest: Codable, Identifiable {
    let id: String
    let title: String
    let type: CampaignRequestType
    let subtitle: String
    let date: Date
    let imageURL: String
    
} 
