import SwiftUI

@MainActor
final class MyPageRouter: BaseRouter {
    typealias RouteType = MyPageRoute
    @Published var path = NavigationPath()
}

struct MyPageNavigationStack: View {
    @EnvironmentObject private var router: MyPageRouter
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack (spacing: 0){
                MyPageView()
                CDBottomTab(selectedTab: $selectedTab)
            }
            .onAppear {
                router.logScreenView(for: .myPage)
            }
            .navigationDestination(for: MyPageRoute.self) { route in
                destinationView(for: route)
                    .swipeBackDisabled(route.disableSwipeBack)
                    .onAppear {
                        router.logScreenView(for: route)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: MyPageRoute) -> some View {
        switch route {
        case .myPage:
            VStack (spacing: 0){
                MyPageView()
                CDBottomTab(selectedTab: $selectedTab)
            }
        case .agreement: AgreementView()
        case .mediaConnect: ManageSNSView()
        case .profileSetting: ProfileSettingView()
        case .search: SearchView()
        case .notification: NotificationView()
        case .withdrawal: WithdrawalView()
        case .manageSNS: ManageSNSView()
        case .myPageDetail(let type): WebDetailView(myPageWebType: type)
        }
    }
}

#Preview {
    MyPageNavigationStack(selectedTab: .constant(4))
        .environmentObject(MyPageRouter())
}
