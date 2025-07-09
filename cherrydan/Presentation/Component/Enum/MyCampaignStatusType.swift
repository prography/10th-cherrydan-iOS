enum MyCampaignStatusType: String, CaseIterable, Codable {
    case apply
    case selected
    case nonSelected
    case registered
    case ended
    
    var title: String {
        switch self {
        case .apply:
            "찜"
        case .selected:
            "신청"
        case .nonSelected:
            "미선정"
        case .registered:
            "등록"
        case .ended:
            "종료"
        }
    }
}
