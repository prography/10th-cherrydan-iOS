enum SortType: String, CaseIterable, Hashable {
    case popular = "popular"
    case latest = "latest"
    case deadline = "deadline"
    case lowCompetition = "low_competition"
    
    var displayName: String {
        switch self {
        case .popular:
            "인기순"
        case .deadline:
            "마감임박순"
        case .latest:
            "최신순"
        case .lowCompetition:
            "낮은 경쟁순"
        }
    }
}
