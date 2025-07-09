import Foundation

@MainActor
class MyPageViewModel: ObservableObject {
    @Published var user: User = User(email: "test@naver.com", name: "회원", nickname: "회원", birthYear: 2000)
    @Published var isLoading: Bool = false
    @Published var version: String = ""
    @Published var isVersionLoading: Bool = false
    
    private let userRepository: UserRepository
    private let myPageRepository: MyPageRepository
    
    init(
        userRepository: UserRepository = UserRepository(),
        myPageRepository: MyPageRepository = MyPageRepository(),
    ) {
        self.userRepository = userRepository
        self.myPageRepository = myPageRepository
        loadUser()
        loadVersion()
    }
    
    func loadUser() {
        isLoading = true
        
        Task {
            do {
                let response = try await userRepository.getUser()
                user = response.result.toUser()
               
                isLoading = false
            } catch {
                print(error)
                isLoading = false
            }
        }
    }
    
    func loadVersion() {
        isVersionLoading = true
        
        Task {
            do {
                version = try await myPageRepository.getVersion()
                isVersionLoading = false
            } catch {
                print(error)
                isVersionLoading = false
            }
        }
    }
}
