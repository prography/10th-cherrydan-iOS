enum CampaignStatusType: CaseIterable, Codable {
    case apply
    case selected
    case notSelected
    case reviewing
    case ended
    
    var apiValue: String {
        switch self {
        case .apply:
            "APPLY"
        case .selected:
            "SELECTED"
        case .notSelected:
            "NOT_SELECTED"
        case .reviewing:
            "REVIEWING"
        case .ended:
            "ENDED"
        }
    }
}

enum CampaignStatusCategory: CaseIterable {
    case liked
    case applied
    case result
    case writingReview
    case writingDone
    
    var displayText: String {
        switch self {
        case .liked:
            "관심 공고"
        case .applied:
            "지원한 공고"
        case .result:
            "선정 결과"
        case .writingReview:
            "리뷰 작성 중"
        case .writingDone:
            "작성 완료"
        }
    }
    
    var statusType: [CampaignStatusType] {
        switch self {
        case .liked:
            []
        case .applied:
            [.apply]
        case .result:
            [.selected, .notSelected]
        case .writingReview:
            [.reviewing]
        case .writingDone:
            [.ended]
        }
    }
    
    var primaryStatusType: CampaignStatusType? {
        switch self {
        case .liked:
            nil
        case .applied:
            .apply
        case .result:
            .selected
        case .writingReview:
            .reviewing
        case .writingDone:
            .ended
        }
    }
    
    var secondaryStatusType: CampaignStatusType? {
        switch self {
        case .result:
            .notSelected
        default:
            nil
        }
    }
    
    var mainSectionTitle: String {
        switch self {
        case .liked:
            "신청 가능한 공고"
        case .applied:
            "지원한 공고"
        case .result:
            "선정된 공고"
        case .writingReview:
            "리뷰 작성할 공고"
        case .writingDone:
            "리뷰 작성 완료한 공고"
        }
    }
    
    var closedSectionTitle: String? {
        switch self {
        case .liked:
            "신청 마감된 공고"
        case .result:
            "선정되지 않은 공고"
        default:
            nil
        }
    }
}
