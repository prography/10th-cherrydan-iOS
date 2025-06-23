import SwiftUI

struct CherrydanView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var popupManager = PopupManager.shared
    @StateObject private var tabBar = TabBarManager.shared
    
    @StateObject private var homeRouter = HomeRouter()
    @StateObject private var noticeBoardRouter = NoticeBoardRouter()
    @StateObject private var myPageRouter = MyPageRouter()
    
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if authManager.isLoggedIn {
                ZStack {
                    VStack(spacing: 0) {
                        switch(selectedTab) {
                        case 0:
                            CategoryView()
                        case 1:
                            NoticeBoardNavigationStack()
                                .environmentObject(noticeBoardRouter)
                        case 2:
                            HomeNavigationStack()
                                .environmentObject(homeRouter)
                        case 3:
                            MyCampaignView()
                        default:
                            MyPageNavigationStack()
                                .environmentObject(myPageRouter)
                        }
                    }
                    
                    if !tabBar.isHidden {
                        HMBottomTab(selectedTab: $selectedTab)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
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
            data: popupManager.currentPopupData
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
