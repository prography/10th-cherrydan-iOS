import SwiftUI

@MainActor
final class NoticeBoardRouter: BaseRouter {
    typealias RouteType = NoticeBoardRoute
    @Published var path = NavigationPath()
}

struct NoticeBoardNavigationStack: View {
    @EnvironmentObject private var router: NoticeBoardRouter
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack (spacing: 0){
                NoticeBoardView()
                CDBottomTab(selectedTab: $selectedTab)
            }
            .navigationDestination(for: NoticeBoardRoute.self) { route in
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
    private func destinationView(for route: NoticeBoardRoute) -> some View {
        switch route {
        case .noticeDetail(let noticeId): NoticeDetailView(noticeId: noticeId)
        case .notification: NotificationView()
        case .search: SearchView()
        }
    }
}

#Preview {
    NoticeBoardNavigationStack(selectedTab: .constant(3))
        .environmentObject(NoticeBoardRouter())
}
