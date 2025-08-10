import Foundation

@MainActor
class KeywordSettingsViewModel: ObservableObject {
    @Published var userKeywords: [UserKeyword] = []
    @Published var newKeyword: String = ""
    @Published var isLoading: Bool = false
    
    // 키워드 제한 상수
    private let maxKeywordCount = 5
    private let minKeywordLength = 2
    private let maxKeywordLength = 10
    
    private let keywordRepository: KeywordRepository
    
    init(keywordRepository: KeywordRepository = KeywordRepository()) {
        self.keywordRepository = keywordRepository
        loadUserKeywords()
    }
    
    func loadUserKeywords() {
        Task {
            do {
                isLoading = true
                let response = try await keywordRepository.getUserKeywords()
                userKeywords = response.result.map { $0.toUserKeyword() }
            } catch {
                print("KeywordSettingsViewModel Error: \(error)")
                ToastManager.shared.show(.errorWithMessage("키워드 목록을 불러오는 중 오류가 발생했습니다."))
            }
            
            isLoading = false
        }
    }
    
    /// 키워드 유효성 검사
    private func validateKeyword(_ keyword: String) -> (isValid: Bool, errorMessage: String?) {
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 빈 문자열 체크
        guard !trimmedKeyword.isEmpty else {
            return (false, "키워드를 입력해주세요.")
        }
        
        // 글자수 체크
        if trimmedKeyword.count < minKeywordLength {
            return (false, "키워드는 최소 \(minKeywordLength)자 이상 입력해주세요.")
        }
        
        if trimmedKeyword.count > maxKeywordLength {
            return (false, "키워드는 최대 \(maxKeywordLength)자까지 입력 가능합니다.")
        }
        
        // 최대 키워드 개수 체크
        if userKeywords.count >= maxKeywordCount {
            return (false, "키워드는 최대 \(maxKeywordCount)개까지 등록 가능합니다.")
        }
        
        // 중복 키워드 체크
        if userKeywords.contains(where: { $0.keyword.lowercased() == trimmedKeyword.lowercased() }) {
            return (false, "이미 등록된 키워드입니다.")
        }
        
        return (true, nil)
    }
    
    /// 새 키워드 등록
    func addKeyword() {
        let validation = validateKeyword(newKeyword)
        
        guard validation.isValid else {
            if let errorMessage = validation.errorMessage {
                ToastManager.shared.show(.errorWithMessage(errorMessage))
            }
            return
        }
        
        Task {
            do {
                isLoading = true
                try await keywordRepository.addUserKeyword(keyword: newKeyword.trimmingCharacters(in: .whitespacesAndNewlines))
                newKeyword = ""
                loadUserKeywords() // 목록 새로고침
            } catch {
                print("KeywordSettingsViewModel Add Error: \(error)")
                ToastManager.shared.show(.errorWithMessage("키워드 등록 중 오류가 발생했습니다."))
            }
            
            isLoading = false
        }
    }
    
    func deleteKeyword(keywordId: Int) async {
        isLoading = true
        
        do {
            try await keywordRepository.deleteUserKeyword(keywordId: keywordId)
            loadUserKeywords()
        } catch {
            print("KeywordSettingsViewModel Delete Error: \(error)")
            ToastManager.shared.show(.errorWithMessage("키워드 삭제 중 오류가 발생했습니다."))
        }
        
        isLoading = false
    }
    
    /// 키워드 등록 가능 여부 확인
    var canAddKeyword: Bool {
        return userKeywords.count < maxKeywordCount
    }
    
    /// 현재 키워드 개수 정보
    var keywordCountInfo: String {
        return "\(userKeywords.count)/\(maxKeywordCount)"
    }
} 
