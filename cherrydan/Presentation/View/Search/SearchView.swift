import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SearchViewModel()
    @State private var showSortBottomSheet = false
    @State private var showFilterSideMenu = false
    
    var body: some View {
        ZStack {
            CDScreen(horizontalPadding: 0) {
                headerSection
                
                ScrollView {
                    if viewModel.searchText.isEmpty {
                        VStack(spacing: 36) {
//                        recommendedCategorySection
                            recentSearchSection
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                    } else if viewModel.isSubmitted {
                        // 제출 후 그리드 표시
                        campaignGridSection
                    } else {
                        // 텍스트 입력 중 세로 리스트 표시
                        searchResultsSection
                    }
                }
                
                Spacer()
            }
            
            // 필터 사이드 메뉴
            if showFilterSideMenu {
                SearchFilterSideMenu(
                    viewModel: viewModel,
                    isPresented: $showFilterSideMenu
                )
            }
        }
        .sheet(isPresented: $showSortBottomSheet) {
            SortBottomSheet(
                isPresented: $showSortBottomSheet,
                selectedSortType: $viewModel.selectedSortType,
                onSortTypeSelected: viewModel.selectSortType
            )
        }
        .onAppear {
            viewModel.loadRecentSearches()
        }
    }
    
    
    private var headerSection: some View {
        HStack(alignment: .center, spacing: 0) {
            Button(action: {
                dismiss()
            }) {
                Image("chevron_left")
            }
            
            CDTextField(text: $viewModel.searchText, placeholder: "검색어를 입력해주세요", onSubmit: {
                viewModel.submitSearch()
            })
            
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
            ForEach(viewModel.autoCompleteResults) { result in
                searchResultRow(result)
            }
        }
    }
    
    private var campaignGridSection: some View {
        LazyVStack(spacing: 16) {
            // 검색 결과 헤더
            HStack(spacing: 0) {
                Text("검색 결과")
                    .font(.m5b)
                    .foregroundStyle(.gray9)
                
                Text("총 \(viewModel.totalCount)개")
                    .font(.m5r)
                    .foregroundStyle(.gray5)
                
                Spacer()
                
                Button(action: {
                    showFilterSideMenu = true
                }) {
                    Image("filter")
                        .padding(.trailing, 16)
                }
                
                Button(action: {
                    showSortBottomSheet = true
                }) {
                    HStack(spacing: 4) {
                        Text(viewModel.selectedSortType.displayName)
                            .font(.m5r)
                            .foregroundStyle(.gray5)
                        
                        Image("chevron_down")
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // 캠페인 그리드
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ], spacing: 16) {
                ForEach(viewModel.searchResults) { campaign in
                    CampaignCardView(campaign: campaign)
                        .frame(maxHeight: 320, alignment: .top)
                }
            }
            .padding(.horizontal, 16)
            
            // 더 보기 버튼
            if viewModel.hasMorePages {
                Button(action: {
                    viewModel.loadNextPage()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(0.8)
                    } else {
                        Text("더 보기")
                            .font(.m4r)
                            .foregroundStyle(.gray5)
                    }
                }
                .frame(height: 40)
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 24)
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
                    viewModel.deleteAllSearchRecords()
                }) {
                    Text("전체 삭제")
                        .font(.m5r)
                        .foregroundStyle(.gray5)
                }
            }
            
            VStack(spacing: 0) {
                if viewModel.recentSearches.isEmpty {
                    Text("검색기록이 비어있어요.")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.recentSearches) { searchItem in
                        recentSearchItem(searchItem)
                    }
                }
            }
        }
    }
    
    private func searchResultRow(_ result: SearchRecord) -> some View {
        HStack(spacing: 4) {
            Image("search_sm")
            
            highlightedText(text: result.text, searchTerm: viewModel.searchText)
                .font(.m5r)
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectAutoCompleteResult(result)
        }
    }
    
    private func recentSearchItem(_ searchItem: SearchRecord) -> some View {
        HStack(spacing: 12) {
            Image("clock")
            
            Text(searchItem.text)
                .font(.m5r)
                .foregroundStyle(.gray9)
            
            Spacer()
            
            Button(action: {
                viewModel.deleteSearchRecord(searchItem.id)
            }) {
                Image("close")
            }
        }
        .padding(.bottom, 16)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectRecentSearch(searchItem.text)
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
