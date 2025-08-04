enum NotificationType: CaseIterable {
    case activity, custom
    
    var title: String {
        switch self {
        case .activity: return "활동"
        case .custom: return "맞춤형"
        }
    }
}
