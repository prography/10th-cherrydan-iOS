import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @ObservedObject private var tabBar = TabBarManager.shared
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                switch(selectedTab) {
                case 0:
                    HomeView()
                case 1:
                    MyCampaignView()
                case 2:
                    CategoryView()
                case 3:
                    MyPageView()
                default:
                    HomeView()
                }
            }
            
            if !tabBar.isHidden {
                bottomTab
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
        }
        .background(.white)
        .ignoresSafeArea(.container, edges: .bottom)
    }
    
    @ViewBuilder
    private var bottomTab: some View {
        let tabBarText = [
            ("home","홈"),
            ("my_campaigns","내 체험단"),
            ("writing_guide","작성 가이드"),
            ("my","마이페이지")
        ]
        
        VStack(spacing: 0) {
            Rectangle()
                .fill(.pBeige)
                .frame(height:2)
            
            HStack(alignment: .center, spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    let isFocused = selectedTab == index
                    
                    Button(action: {
                        selectedTab = index
                    } ) {
                        VStack(spacing: 4) {
                            Image("\(tabBarText[index].0)\(isFocused ? "_focused": "")")
                            
                            Text(tabBarText[index].1)
                                .font(.m5r)
                                .foregroundStyle(isFocused ? .mPink3 : .mPink1)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 32)
            .frame(height: 96)
            .background(.white)
        }
    }
}

#Preview {
    MainTabView()
}
