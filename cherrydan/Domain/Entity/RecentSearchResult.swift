import Foundation

struct RecentSearchResult: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let iconName: String = "clock"
    
    static let dummyList: [RecentSearchResult] = [
        RecentSearchResult(text: "강남 맛집"),
        RecentSearchResult(text: "효소 제품"),
        RecentSearchResult(text: "맛있는 파자 분당점")
    ]
}

