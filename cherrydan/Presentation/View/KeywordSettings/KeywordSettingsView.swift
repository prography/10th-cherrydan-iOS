import SwiftUI

struct KeywordSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = KeywordSettingsViewModel()
    @FocusState private var isKeywordFocused: Bool
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: "키워드 알림 설정 (\(viewModel.userKeywords.count))/5)")
            .padding(.horizontal, 16)
            
            VStack(spacing: 24) {
                keywordInputSection
                myKeywordsSection
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }
    
    private var keywordInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                TextField("검색어를 입력해 주세요.", text: $viewModel.newKeyword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isKeywordFocused)
                    .onSubmit {
                        Task {
                            await viewModel.addKeyword()
                        }
                    }
                
                Button(action: {
                    Task {
                        await viewModel.addKeyword()
                    }
                }) {
                    Text("등록")
                        .font(.m4r)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray5, in: RoundedRectangle(cornerRadius: 8))
                }
                .disabled(viewModel.newKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    
    private var myKeywordsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("나의 키워드")
                .font(.m3b)
                .foregroundColor(.gray9)
            
            if viewModel.userKeywords.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray4)
                    
                    Text("등록된 키워드가 없습니다")
                        .font(.m4r)
                        .foregroundColor(.gray5)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.userKeywords) { keyword in
                        keywordRow(keyword)
                        if keyword.id != viewModel.userKeywords.last?.id {
                            Divider()
                                .background(Color.gray2)
                        }
                    }
                }
            }
        }
    }
    
    private func keywordRow(_ keyword: UserKeyword) -> some View {
        HStack {
            Text(keyword.keyword)
                .font(.m4r)
                .foregroundColor(.gray9)
            
            Spacer()
            
            Button(action: {
                Task {
                    await viewModel.deleteKeyword(keywordId: keyword.id)
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray5)
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    KeywordSettingsView()
} 
