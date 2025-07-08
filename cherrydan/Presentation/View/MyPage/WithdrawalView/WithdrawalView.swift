import SwiftUI

struct WithdrawalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedReasons: Set<WithdrawalReason> = []
    @State private var isChecked = false
    @State private var nickname: String = "회원"
    @State private var isLoading: Bool = false
    private var user: UserRepository
    
    init(user: UserRepository = UserRepository()){
        self.user = user
    }
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: "회원 탈퇴")
                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("\(nickname)님\n정말 체리단을 떠나실 건가요?🥲")
                        .font(.t2)
                        .foregroundStyle(.gray9)
                    
                    
                    withdrawalNoticeSection
                    
                    withdrawalReasonSection
                    
                    Spacer(minLength: 40)
                    
                    
                    Text("그동안 체리단을 사랑해 주셔서 감사합니다!")
                        .font(.m3b)
                        .foregroundStyle(.gray9)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CDButton(text: "체리단 떠나기",
                             isLoading: isLoading,
                             isDisabled: !isChecked && selectedReasons.isEmpty
                    ){
                        Task {
                            do {
                                isLoading = true
                                let success = try await user.deleteUser()
                                if success {
                                    isLoading = false
                                    AuthManager.shared.logout()
                                }
                            } catch {
                                isLoading = false
                                print("error in withDrawal")
                            }
                        }
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var withdrawalNoticeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("떠나시기 전, 아래의 내용을 확인해 주세요.")
                .font(.m3b)
                .foregroundStyle(.gray9)
            
            Button(action: { isChecked.toggle() }){
                HStack(alignment: .top, spacing: 8) {
                    Image("check_circle\(isChecked ? "_filled" : "_empty")")
                    
                    Text("비밀정보 재가입 이용을 막기 위해 회원정보 및 패턴의 내역은 1년간 보관하고 있어요.")
                        .font(.m5r)
                        .foregroundStyle(.gray9)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
    
    private var withdrawalReasonSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("탈퇴 사유를 알려주세요.")
                .font(.m3b)
                .foregroundStyle(.gray9)
            
            Text("더 나은 서비스를 위하여 위해서 탈퇴 전 정보 수집하고 있어요.\n복수 선택 가능")
                .font(.m5r)
                .foregroundStyle(.gray4)
                .multilineTextAlignment(.leading)
            
            Text("*중복 선택 가능")
                .font(.m6r)
                .foregroundStyle(.mPink3)
                .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                withdrawalReasonItem(.serviceIssue)
                withdrawalReasonItem(.lackOfContent)
                withdrawalReasonItem(.difficultyOfUse)
            }
        }
    }
    
    
    private func withdrawalReasonItem(_ reason: WithdrawalReason) -> some View {
        Button(action: {
            if selectedReasons.contains(reason) {
                selectedReasons.remove(reason)
            } else {
                selectedReasons.insert(reason)
            }
        }) {
            HStack(spacing: 8) {
                Image("check_circle\(selectedReasons.contains(reason) ? "_filled" : "_empty")")
                
                Text(reason.title)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
                
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
    
    private func performWithdrawal() {
        // TODO: 회원탈퇴 API 호출
        print("회원탈퇴 사유: \(selectedReasons.map { $0.title })")
        
        // 임시로 로그아웃 처리
        AuthManager.shared.logout()
        dismiss()
    }
}

// MARK: - 탈퇴 사유 열거형
enum WithdrawalReason: CaseIterable, Hashable {
    case serviceIssue
    case lackOfContent  
    case difficultyOfUse
    
    var title: String {
        switch self {
        case .serviceIssue:
            return "서비스 이용 방법을 잘 모르겠어요."
        case .lackOfContent:
            return "콘텐츠를 확인하고, 관리하기 어려워요."
        case .difficultyOfUse:
            return "콘텐츠에 잘 선정되지 않아요."
        }
    }
}

#Preview {
    WithdrawalView()
}
