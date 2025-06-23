import SwiftUI

@MainActor
final class MyPageRouter: BaseRouter {
    typealias RouteType = MyPageRoute
    @Published var path = NavigationPath()
}

struct MyPageNavigationStack: View {
    @EnvironmentObject private var router: MyPageRouter
    
    var body: some View {
        NavigationStack(path: $router.path) {
            MyPageView()
                .navigationDestination(for: MyPageRoute.self) { route in
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
    private func destinationView(for route: MyPageRoute) -> some View {
        switch route {
        case .agreement: AgreementView()
        case .mediaConnect: MediaConnectView()
        case .profileSetting: ProfileSettingView()
        }
    }
} 

#Preview {
    MyPageNavigationStack()
        .environmentObject(MyPageRouter())
}
