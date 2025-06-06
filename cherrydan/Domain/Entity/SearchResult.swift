import Foundation

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let text: String
    
    static let dummy: [SearchResult] = [
        SearchResult(text: "강남스마트신장관리"),
        SearchResult(text: "강남구역"),
        SearchResult(text: "강남카페"),
        SearchResult(text: "강남역"),
        SearchResult(text: "강남유치원"),
        SearchResult(text: "강남신세계"),
        SearchResult(text: "강남삼겹살"),
        SearchResult(text: "강남떡볶이"),
        SearchResult(text: "강남아메리카노")
    ]
}
