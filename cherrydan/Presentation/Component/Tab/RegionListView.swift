import SwiftUI

struct RegionListView: View {
    @State private var selectedRegionGroup: RegionGroup? = nil
    
    let onSelectRegion: ((RegionGroup?, SubRegion?) -> Void)
    
    var body: some View {
        regionSelectSection
    }
    
    private var regionSelectSection: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(RegionGroup.allCases, id: \.self) { regionGroup in
                    regionGroupButton(regionGroup)
                }
                
                Spacer()
            }
            .frame(width: 120)
            .background(.gray1)
            
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(RegionGroup.allCases, id: \.self) { regionGroup in
                            let isSelected = regionGroup == selectedRegionGroup
                            
                            VStack(alignment: .leading, spacing: 0) {
                                regionTitleButton(regionGroup)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                                    ForEach(regionGroup.subRegions, id: \.self) { subregion in
                                        regionDetailButton(subregion)
                                    }
                                }
                                
                                if regionGroup != RegionGroup.jeju {
                                    Divider()
                                        .background(isSelected ? .mPink1 : .gray2)
                                        .padding(.top, 16)
                                }
                            }
                            .id(regionGroup.startIndex)
                        }
                    }
                    .onChange(of: selectedRegionGroup) { _, newValue in
                        withAnimation(.mediumSpring) {
                            proxy.scrollTo(selectedRegionGroup?.startIndex, anchor: .top)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
    }
    
    private func regionGroupButton(_ regionGroup: RegionGroup) -> some View {
        Button(action: {
            selectedRegionGroup = regionGroup
        }) {
            HStack {
                Text(regionGroup.displayName)
                    .font(.m4r)
                    .foregroundStyle(selectedRegionGroup == regionGroup ? .gray9 : .gray5)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .background(selectedRegionGroup == regionGroup ? .gray0 : .clear)
        }
    }
    
    @ViewBuilder
    private func regionTitleButton(_ regionGroup: RegionGroup) -> some View {
        let isSelected = regionGroup == selectedRegionGroup
        
        Button(action: {
            onSelectRegion(regionGroup, nil)
        }){
            HStack {
                Text("\(regionGroup.displayName)\(regionGroup == .seoul ? " 전체." : ".")")
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
    
    private func regionDetailButton(_ subregion: SubRegion) -> some View {
        Button(action: {
            onSelectRegion(nil, subregion)
        }) {
            Text(subregion.displayName)
                .font(.m5r)
                .foregroundStyle(.gray9)
                .frame(width: 110, height: 40, alignment: .leading)
        }
    }
}
    

#Preview {
    RegionListView(onSelectRegion: {_,_ in})
}
