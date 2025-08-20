enum CampaignStatusType: CaseIterable, Codable {
    case apply
    case selected
    case notSelected
    case registered
    case ended
    
    var apiValue: String {
        switch self {
        case .apply:
            "APPLY"
        case .selected:
            "SELECTED"
        case .notSelected:
            "NOT_SELECTED"
        case .registered:
            "REGISTERED"
        case .ended:
            "ENDED"
        }
    }
    
    var displayText: String {
        switch self {
        case .apply:
            "관심 공고"
        case .selected:
            "지원한 공고"
        case .notSelected:
            "선정 결과"
        case .registered:
            "리뷰 작성 중"
        case .ended:
            "작성 완료"
        }
    }
}
