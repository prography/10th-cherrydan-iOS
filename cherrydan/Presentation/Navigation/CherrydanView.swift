import SwiftUI

struct CherrydanView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var popupManager = PopupManager.shared
    
    @StateObject private var homeRouter = HomeRouter()
    @StateObject private var categoryRouter = CategoryRouter()
    @StateObject private var noticeBoardRouter = NoticeBoardRouter()
    @StateObject private var myCampaignRouter = MyCampaignRouter()
    @StateObject private var myPageRouter = MyPageRouter()
    
    
    @StateObject private var viewModel = CherrydanViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if authManager.isLoggedIn {
                VStack(spacing: 0) {
                    switch(selectedTab) {
                    case 0:
                        HomeNavigationStack(selectedTab: $selectedTab)
                            .environmentObject(homeRouter)
                    case 1:
                        MyPageNavigationStack(selectedTab: $selectedTab)
                            .environmentObject(myPageRouter)
                    default:
                        MyPageNavigationStack(selectedTab: $selectedTab)
                            .environmentObject(myPageRouter)
                    }
                }
            } else {
                OnboardingView()
            }
        }
        .background(.gray0)
        .ignoresSafeArea(.container, edges: .bottom)
        .presentPopup(
            isPresented: $popupManager.popupPresented,
            data: popupManager.currentPopupType
        )
        .onChange(of: authManager.isLoggedIn) { _, isLoggedIn in
            if !isLoggedIn {
                homeRouter.reset()
                noticeBoardRouter.reset()
                myPageRouter.reset()
                
                selectedTab = 0
            }
        }
    }
}

#Preview {
    CherrydanView()
}
