import Foundation

@MainActor
class KeywordSettingsViewModel: ObservableObject {
    @Published var userKeywords: [UserKeyword] = []
    @Published var newKeyword: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let keywordRepository: KeywordRepository
    
    init(keywordRepository: KeywordRepository = KeywordRepository()) {
        self.keywordRepository = keywordRepository
        Task {
            await loadUserKeywords()
        }
    }
    
    /// 사용자 키워드 목록 로드
    func loadUserKeywords() async {
        isLoading = true
        
        do {
            let response = try await keywordRepository.getUserKeywords()
            userKeywords = response.result.content.map { $0.toUserKeyword() }
        } catch {
            print("KeywordSettingsViewModel Error: \(error)")
            errorMessage = "키워드 목록을 불러오는 중 오류가 발생했습니다."
        }
        
        isLoading = false
    }
    
    /// 새 키워드 등록
    func addKeyword() {
        guard !newKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        Task {
            do {
                isLoading = true
                try await keywordRepository.addUserKeyword(keyword: newKeyword.trimmingCharacters(in: .whitespacesAndNewlines))
                newKeyword = ""
                await loadUserKeywords() // 목록 새로고침
            } catch {
                print("KeywordSettingsViewModel Add Error: \(error)")
                errorMessage = "키워드 등록 중 오류가 발생했습니다."
            }
            
            isLoading = false
        }
    }
    
    /// 키워드 삭제
    func deleteKeyword(keywordId: Int) async {
        isLoading = true
        
        do {
            try await keywordRepository.deleteUserKeyword(keywordId: keywordId)
            await loadUserKeywords() // 목록 새로고침
        } catch {
            print("KeywordSettingsViewModel Delete Error: \(error)")
            errorMessage = "키워드 삭제 중 오류가 발생했습니다."
        }
        
        isLoading = false
    }
} 
