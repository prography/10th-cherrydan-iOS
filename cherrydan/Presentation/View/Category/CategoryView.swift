import SwiftUI

struct CategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRegion: Region = .seoul
    @State private var selectedCategory: CategoryType = .interestedRegion
    
    var body: some View {
        CHScreen(horizontalPadding: 0) {
            CDHeaderWithLeftContent(){
                Button(action: {
                    dismiss()
                }) {
                    Text("카테고리")
                        .font(.t1)
                        .foregroundStyle(.gray9)
                }
            }
            .padding(.horizontal, 16)
            
            CDTabSection(selectedCategory: $selectedCategory)
                .padding(.top, 24)
            
            regionSelectSection
        }
    }
    
    private var regionSelectSection: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(Region.allCases, id: \.self) { region in
                    regionCategoryButton(region)
                }
                
                Spacer()
            }
            .frame(width: 120)
            .background(.gray1)
            
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(Region.allCases, id: \.self) { region in
                            let isSelected = region == selectedRegion
                            
                            VStack(alignment: .leading, spacing: 0) {
                                regionButton(region)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                                    ForEach(region.subregions, id: \.self) { subregion in
                                        regionDetailButton(subregion)
                                    }
                                }
                                
                                if region != Region.jeju {
                                    Divider()
                                        .background(isSelected ? .mPink1 : .gray2)
                                        .padding(.top, 16)
                                }
                            }
                            .id(region.startIndex)
                        }
                    }
                    .onChange(of: selectedRegion) { _, newValue in
                        withAnimation(.mediumSpring) {
                            proxy.scrollTo(selectedRegion.startIndex, anchor: .top)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
    }
    
    private func regionCategoryButton(_ region: Region) -> some View {
        Button(action: {
            selectedRegion = region
        }) {
            HStack {
                Text(region.rawValue)
                    .font(.m4r)
                    .foregroundStyle(selectedRegion == region ? .gray9 : .gray5)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .background(selectedRegion == region ? .white : .clear)
        }
    }
    
    @ViewBuilder
    private func regionButton(_ region: Region) -> some View {
        let isSelected = region == selectedRegion
        Button(action: {
            
        }){
            HStack {
                Text("\(region.rawValue)\(region == .seoul ? " 전체." : ".")")
                    .font(isSelected ? .m4b : .m4r)
                    .foregroundStyle(isSelected ? .white : .gray9)
                    .padding(.horizontal, isSelected ? 16 : 0)
                    .padding(.vertical, 8)
                    .background(isSelected ? .mPink2 : .clear, in: RoundedRectangle(cornerRadius: 99))
                    .padding(.vertical, 12)
                
                Spacer()
                
                Image("chevron_right")
            }
        }
    }
    
    private func regionDetailButton(_ region: String) -> some View {
        Button(action: {
            // 세부 지역 선택 액션
        }) {
            Text(region)
                .font(.m5r)
                .foregroundStyle(.gray9)
                .frame(width: 110, height: 40, alignment: .leading)
        }
    }
}

#Preview {
    CategoryView()
}
