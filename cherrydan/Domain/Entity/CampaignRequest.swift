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
    
    static let sampleData: [CampaignRequest] = [
        CampaignRequest(
            id: "1",
            title: "선정 여부를 확인해 보세요!",
            type: .selectionRequest,
            subtitle: "[화모아] 맛있는 효소 밤스 세럼",
            date: Date(timeIntervalSince1970: 1751242800), // 2025.06.30
            imageURL: "https://picsum.photos/200/200"
        ),
        CampaignRequest(
            id: "2",
            title: "등록 완료를 확인해 주세요!",
            type: .registrationRequest,
            subtitle: "[뷰티] 수분 크림 체험단",
            date: Date(timeIntervalSince1970: 1748564400), // 2025.06.15
            imageURL: "https://picsum.photos/201/200"
        ),
        CampaignRequest(
            id: "3",
            title: "체험이 종료되었습니다!",
            type: .terminationRequest,
            subtitle: "[건강] 프로바이오틱스",
            date: Date(timeIntervalSince1970: 1746058800), // 2025.05.30
            imageURL: "https://picsum.photos/202/200"
        )
    ]
} 
