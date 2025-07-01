import SwiftUI

@MainActor
final class CategoryRouter: BaseRouter {
    typealias RouteType = CategoryRoute
    @Published var path = NavigationPath()
}

struct CategoryNavigationStack: View {
    @EnvironmentObject private var router: CategoryRouter
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack (spacing: 0){
                CategoryView()
                CHBottomTab(selectedTab: $selectedTab)
            }
            .navigationDestination(for: CategoryRoute.self) { route in
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
    private func destinationView(for route: CategoryRoute) -> some View {
        switch route {
        case .categoryDetail: EmptyView()
        }
    }
}

#Preview {
    CategoryNavigationStack(selectedTab: .constant(2))
        .environmentObject(CategoryRouter())
}
