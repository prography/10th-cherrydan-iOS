import SwiftUI

@MainActor
final class MyCampaignRouter: BaseRouter {
    typealias RouteType = MyCampaignRoute
    @Published var path = NavigationPath()
}

struct MyCampaignNavigationStack: View {
    @EnvironmentObject private var router: MyCampaignRouter
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack (spacing: 0){
                MyCampaignView()
                CDBottomTab(selectedTab: $selectedTab)
            }
            .onAppear {
                router.logScreenView(for: .category)
            }
            .navigationDestination(for: MyCampaignRoute.self) { route in
                destinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
                    .onAppear {
                        router.logScreenView(for: route)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: MyCampaignRoute) -> some View {
        switch route {
        case .category:
            VStack (spacing: 0){
                MyCampaignView()
                CDBottomTab(selectedTab: $selectedTab)
            }
        case .categoryDetail: EmptyView()
        case .campaignWeb(let siteNameKr, let campaignSiteUrl):
            CampaignWebView(siteNameKr: siteNameKr, campaignSiteUrl: campaignSiteUrl)
        }
    }
}

#Preview {
    MyCampaignNavigationStack(selectedTab: .constant(2))
        .environmentObject(MyCampaignRouter())
}
