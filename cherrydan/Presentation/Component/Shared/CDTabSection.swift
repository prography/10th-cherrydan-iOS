import SwiftUI

struct CDTabSection: View {
    @Binding var selectedCategory: CampaignType
    var onCategoryChanged: ((CampaignType) -> Void)? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(CampaignType.allCases, id: \.self) { category in
                    tabItem(category)
                    .padding(.horizontal, 12)
                        .onTapGesture { 
                            selectedCategory = category
                            onCategoryChanged?(category)
                        }
                }
                .padding(.horizontal, 2)
            }
        }
        .animation(.fastEaseInOut, value: selectedCategory)
    }
    
    private func tabItem(_ category: CampaignType) -> some View {
        VStack(spacing: 8){
            Text(category.title)
                .font(selectedCategory == category ? .m3b : .m3r)
                .foregroundStyle(selectedCategory == category ? .mPink3 : .gray4)
            
            Rectangle()
                .fill(selectedCategory == category ? .mPink3 : .clear)
                .frame(height: 2)
        }
    }
}
