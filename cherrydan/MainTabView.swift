import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                switch(selectedTab) {
                case 0:
                    HomeView()
                case 1:
                    HomeView()
                case 2:
                    HomeView()
                default:
                    HomeView()
                }
                
                Rectangle()
                    .fill(.pBeige)
                    .frame(height:2)
                
                bottomTab
                    .padding(.horizontal, 32)
            }
            .animation(.fastEaseInOut, value: selectedTab)
        }
    }
    
    @ViewBuilder
    private var bottomTab: some View {
        let tabBarText = [
            ("home","홈"),
            ("my_campaigns","내 체험단"),
            ("writing_guide","작성 가이드"),
            ("my","마이페이지")
        ]

        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<4, id: \.self) { index in
                let isFocused = selectedTab == index
                
                Button(action:{
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
        .frame(height: 80)
    }
}

#Preview {
    MainTabView()
}
