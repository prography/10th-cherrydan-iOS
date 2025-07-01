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
                CHBottomTab(selectedTab: $selectedTab)
            }
            .navigationDestination(for: MyCampaignRoute.self) { route in
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
    private func destinationView(for route: MyCampaignRoute) -> some View {
        switch route {
        case .categoryDetail: EmptyView()
        }
    }
}

#Preview {
    MyCampaignNavigationStack(selectedTab: .constant(2))
        .environmentObject(MyCampaignRouter())
}
