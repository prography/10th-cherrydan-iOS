import Foundation

@MainActor
class MyPageViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var isLoading: Bool = false
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository = UserRepository()) {
        self.userRepository = userRepository
        loadUser()
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
} 
