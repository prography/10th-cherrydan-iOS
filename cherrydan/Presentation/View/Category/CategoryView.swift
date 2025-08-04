import SwiftUI

struct CategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: CategoryRouter
    @State private var selectedCategory: CampaignType = .all
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDHeaderWithLeftContent(
                onSearchClick: {
                    router.push(to: .search)
                }){
                    Text("카테고리")
                        .font(.t1)
                        .foregroundStyle(.gray9)
                }
                .padding(.horizontal, 16)
            
            CDTabSection(selectedCategory: $selectedCategory)
                .padding(.top, 24)
            
            RegionListView { regionGroup, subRegion in
                router.push(to: .categoryDetail(regionGroup: regionGroup, subRegion: subRegion))
            }
        }
    }
}

#Preview {
    CategoryView()
        .environmentObject(CategoryRouter())
}
