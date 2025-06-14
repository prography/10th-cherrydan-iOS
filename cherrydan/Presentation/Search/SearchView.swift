import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var recentSearches: [RecentSearchResult] = RecentSearchResult.dummyList
    @State private var searchResults: [SearchResult] = SearchResult.dummy
    
    var filteredSearchResults: [SearchResult] {
        if searchText.isEmpty {
            return []
        }
        
        return searchResults.filter { $0.text.contains(searchText) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            ScrollView {
                if searchText.isEmpty {
                    VStack(spacing: 36) {
                        recommendedCategorySection
                        
                        recentSearchSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                } else {
                    searchResultsSection
                }
            }
            
            Spacer()
        }
        .background(.white)
    }
    
    private var headerSection: some View {
        HStack(alignment: .center, spacing: 0) {
            Button(action: {
                dismiss()
            }) {
                Image("chevron_left")
            }
            
            CDTextField(text: $searchText, placeholder: "검색어를 입력해주세요", onSubmit: {})
            
            Button(action: {
                dismiss()
            }) {
                Text("닫기")
                    .font(.m4r)
                    .foregroundStyle(.gray9)
                    .padding(.leading, 12)
                    .padding(.vertical, 12)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var searchResultsSection: some View {
        LazyVStack(spacing: 0) {
            ForEach(filteredSearchResults) { result in
                searchResultRow(result)
            }
        }
    }
    
    private var recommendedCategorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("추천 카테고리")
                .font(.m5b)
                .foregroundStyle(.gray9)
            
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    Button(action: {
                        // 제품 카테고리 선택 액션
                    }) {
                        Image("product")
                    }
                    
                    Text("제품")
                }
                
                VStack(spacing: 8) {
                    Button(action: {
                        // 제품 카테고리 선택 액션
                    }) {
                        Image("location")
                    }
                    
                    Text("지역")
                }
                
                Spacer()
            }
            .font(.m5r)
            .foregroundStyle(.gray5)
        }
    }
    
    private var recentSearchSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("최근 검색")
                    .font(.m5b)
                    .foregroundStyle(.gray9)
                
                Spacer()
                
                Button(action: {
                    //
                }) {
                    Text("전체 삭제")
                        .font(.m5r)
                        .foregroundStyle(.gray5)
                }
            }
            
            VStack(spacing: 0) {
                ForEach(recentSearches) {searchItem in
                    recentSearchItem(searchItem)
                }
            }
        }
    }
    
    private func searchResultRow(_ result: SearchResult) -> some View {
        HStack(spacing: 4) {
            Image("search_sm")
            
            highlightedText(text: result.text, searchTerm: searchText)
                .font(.m5r)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            // 검색 결과 선택 액션
        }
    }
    
    private func recentSearchItem(_ searchItem: RecentSearchResult) -> some View {
        HStack(spacing: 12) {
            Image("clock")
            
            Text(searchItem.text)
                .font(.m5r)
                .foregroundStyle(.gray9)
            
            Spacer()
            
            Button(action: {
                //
            }) {
                Image("close")
            }
        }
        .padding(.bottom, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            // 검색어 선택 액션
        }
    }
    
    private func highlightedText(text: String, searchTerm: String) -> some View {
        let ranges = text.ranges(of: searchTerm, options: .caseInsensitive)
        
        if ranges.isEmpty {
            return Text(text)
                .foregroundStyle(.gray9)
        }
        
        var result = Text("")
        var currentIndex = text.startIndex
        
        for range in ranges {
            // 하이라이트 되지 않은 부분 추가
            if currentIndex < range.lowerBound {
                let beforeText = String(text[currentIndex..<range.lowerBound])
                result = result + Text(beforeText).foregroundStyle(.gray9)
            }
            
            // 하이라이트 된 부분 추가
            let highlightedText = String(text[range])
            result = result + Text(highlightedText).foregroundStyle(.mPink3)
            
            currentIndex = range.upperBound
        }
        
        // 마지막 남은 부분 추가
        if currentIndex < text.endIndex {
            let remainingText = String(text[currentIndex...])
            result = result + Text(remainingText).foregroundStyle(.gray9)
        }
        
        return result
    }
}


#Preview {
    SearchView()
} 
