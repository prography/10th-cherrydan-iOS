import SwiftUI

struct RegionSelectionSideMenu: View {
    let currentRegionGroup: RegionGroup?
    let currentSubRegion: SubRegion?
    let onSelectRegion: ((RegionGroup?, SubRegion?) -> Void)
    let onDismiss: () -> Void
    
    init(
        currentRegionGroup: RegionGroup? = nil,
        currentSubRegion: SubRegion? = nil,
        onSelectRegion: @escaping ((RegionGroup?, SubRegion?) -> Void),
        onDismiss: @escaping () -> Void
    ) {
        self.currentRegionGroup = currentRegionGroup
        self.currentSubRegion = currentSubRegion
        self.onSelectRegion = onSelectRegion
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 0) {
                HStack {
                    Text("지역 필터")
                        .font(.t3)
                        .foregroundStyle(.gray9)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: onDismiss) {
                        Image("close")
                            .padding(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .padding(.top, 44)
                
                Divider()
                
                regionSelectSection
            }
            .frame(width: 320)
            .background(.gray0)
            .ignoresSafeArea(.all, edges: .all)
        }
    }
    
    private var regionSelectSection: some View {
        
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                Button(action: {
                    onSelectRegion(nil, nil)
                }){
                    let isSelected = (currentSubRegion == nil && currentRegionGroup == nil)
                    
                    Text("지역 전체")
                        .font(isSelected ? .m4b : .m4r)
                        .foregroundStyle(isSelected ? .gray0 : .gray9)
                        .padding(.horizontal, isSelected ? 16 : 0)
                        .padding(.vertical, 8)
                        .background(isSelected ? .mPink2 : .clear, in: RoundedRectangle(cornerRadius: 99))
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                ForEach(RegionGroup.allCases, id: \.self) { regionGroup in
                    VStack(alignment: .leading, spacing: 0) {
                        regionTitleButton(regionGroup)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                            ForEach(regionGroup.subRegions, id: \.self) { subregion in
                                regionDetailButton(subregion)
                            }
                        }
                        
                        if regionGroup != RegionGroup.jeju {
                            Divider()
                                .background(.gray2)
                                .padding(.top, 16)
                        }
                    }
                    .id(regionGroup.startIndex)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func regionTitleButton(_ regionGroup: RegionGroup) -> some View {
        let isSelected = (currentRegionGroup == regionGroup && currentSubRegion == nil)
        
        Button(action: {
            onSelectRegion(regionGroup, nil)
        }){
            Text("\(regionGroup.displayName)\(regionGroup == .seoul ? " 전체." : ".")")
                .font(isSelected ? .m4b : .m4r)
                .foregroundStyle(isSelected ? .gray0 : .gray9)
                .padding(.horizontal, isSelected ? 16 : 0)
                .padding(.vertical, 8)
                .background(isSelected ? .mPink2 : .clear, in: RoundedRectangle(cornerRadius: 99))
                .padding(.vertical, 12)
        }
    }
    
    private func regionDetailButton(_ subregion: SubRegion) -> some View {
        Button(action: {
            onSelectRegion(nil, subregion)
        }) {
            let isModelSelectedSub = (currentSubRegion == subregion)
            Text(subregion.displayName)
                .font(isModelSelectedSub ? .m5b : .m5r)
                .foregroundStyle(isModelSelectedSub ? .mPink3 : .gray9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 40)
        }
    }
}

#Preview {
    RegionSelectionSideMenu(
        onSelectRegion: { _, _ in },
        onDismiss: {}
    )
}
