import SwiftUI

@MainActor
final class HomeRouter: BaseRouter {
    typealias RouteType = HomeRoute
    @Published var path = NavigationPath()
}

struct HomeNavigationStack: View {
    @EnvironmentObject private var router: HomeRouter
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack (spacing: 0){
                HomeView()
                CDBottomTab(selectedTab: $selectedTab)
            }
            .navigationDestination(for: HomeRoute.self) { route in
                destinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
                    .onAppear {
                        // print("📊 Main Analytics: \(route.analyticsName)")
                        // print("🔒 SwipeBack enabled: \(route.disableSwipeBack)")
                    }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .search: SearchView()
        case .notification: NotificationView()
        case .campaignWeb(let campaignSite, let campaignSiteUrl):
            CampaignWebView(campaignSite: campaignSite, campaignSiteUrl: campaignSiteUrl)
        }
    }
}

#Preview {
    HomeNavigationStack(selectedTab: .constant(2))
        .environmentObject(HomeRouter())
}
