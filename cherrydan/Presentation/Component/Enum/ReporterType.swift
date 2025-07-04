import Foundation

enum ReporterType: String, CaseIterable, Codable {
    case all = "all"
    case reporter = "reporter"
    case nonReporter = "non_reporter"
    
    var displayName: String {
        switch self {
        case .all: return "전체"
        case .reporter: return "기자단"
        case .nonReporter: return "일반"
        }
    }
} 
