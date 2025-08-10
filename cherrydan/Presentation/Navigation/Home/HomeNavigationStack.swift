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
            .onAppear {
                router.logScreenView(for: .home)
            }
            .navigationDestination(for: HomeRoute.self) { route in
                destinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
                    .onAppear {
                        router.logScreenView(for: route)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .home:
            VStack (spacing: 0) {
                HomeView()
                CDBottomTab(selectedTab: $selectedTab)
            }
        case .search: SearchView()
        case .notification: NotificationView()
        case .selectRegion(let viewModel): SelectRegionView(viewModel: viewModel)
        case .campaignWeb(let siteNameKr, let campaignSiteUrl):
            CampaignWebView(siteNameKr: siteNameKr, campaignSiteUrl: campaignSiteUrl)
        case .keywordSettings: KeywordSettingsView()
        case .keywordAlertDetail(let keyword): KeywordNotificationDetailView(keyword: keyword)
        }
    }
}

#Preview {
    HomeNavigationStack(selectedTab: .constant(2))
        .environmentObject(HomeRouter())
}
