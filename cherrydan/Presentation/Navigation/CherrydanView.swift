import SwiftUI

struct CherrydanView: View {
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var popupManager = PopupManager.shared
    
    @StateObject private var homeRouter = HomeRouter()
    @StateObject private var categoryRouter = CategoryRouter()
    @StateObject private var noticeBoardRouter = NoticeBoardRouter()
    @StateObject private var myCampaignRouter = MyCampaignRouter()
    @StateObject private var myPageRouter = MyPageRouter()
    
    @State private var selectedTab = 2
    
    var body: some View {
        Group {
            if authManager.isLoggedIn {
                ZStack {
                    VStack(spacing: 0) {
                        switch(selectedTab) {
                        case 0:
                            CategoryNavigationStack(selectedTab: $selectedTab)
                                .environmentObject(categoryRouter)
                        case 1:
                            NoticeBoardNavigationStack(selectedTab: $selectedTab)
                                .environmentObject(noticeBoardRouter)
                        case 2:
                            HomeNavigationStack(selectedTab: $selectedTab)
                                .environmentObject(homeRouter)
                        case 3:
                            MyCampaignNavigationStack(selectedTab: $selectedTab)
                                .environmentObject(myCampaignRouter)
                        default:
                            MyPageNavigationStack(selectedTab: $selectedTab)
                                .environmentObject(myPageRouter)
                        }
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
                
                selectedTab = 2
            }
        }
    }
}

#Preview {
    CherrydanView()
}
