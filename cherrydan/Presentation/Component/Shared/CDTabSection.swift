import SwiftUI

struct CDTabSection: View {
    @Binding var selectedTab: Int
    let data: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(0..<data.count, id: \.self) { index in
                    tabItem(index)
                        .onTapGesture { selectedTab = index }
                }
                .padding(.horizontal, 8)
            }
            .padding(.horizontal, 8)
        }
        .animation(.fastEaseInOut, value: selectedTab)
    }
    
    private func tabItem(_ index:Int) -> some View {
        VStack(spacing: 8){
            Text(data[index])
                .font(.m3b)
                .foregroundColor(selectedTab == index ? .mPink3 : .gray4)
                .padding(.horizontal, 4)
            
            Rectangle()
                .fill(index == selectedTab ? .mPink3 : .clear)
                .frame(height: 2)
        }
    }
}
