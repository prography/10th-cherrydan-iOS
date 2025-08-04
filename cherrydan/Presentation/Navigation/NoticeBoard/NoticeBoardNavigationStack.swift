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
            .onAppear {
                router.logScreenView(for: .noticeBoard)
            }
            .navigationDestination(for: NoticeBoardRoute.self) { route in
                destinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
                    .onAppear {
                        router.logScreenView(for: route)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: NoticeBoardRoute) -> some View {
        switch route {
        case .noticeBoard:
            VStack (spacing: 0){
                NoticeBoardView()
                CDBottomTab(selectedTab: $selectedTab)
            }
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
