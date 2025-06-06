import SwiftUI

struct CategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var selectedRegion: Int = 0
    
    private let categories = ["관심 지역", "제품", "기자단", "SNS 플랫폼", "체험단 플랫폼", "지역 맞춤"]
    private let regionStartIndex = [0, 16, 26, 32, 39, 45 ,51, 55]
    private let regionData: [String: [String]] = [
        "서울 전체": ["강남/논현", "강동/잠실", "강서/목동", "건대/성시티", "관악/신림", "교대/서현", "노원/강북", "명동/이태원", "삼성/선릉", "송파/잠실", "수유/동대문", "신촌/이대", "압구정/신사", "여의도/영등포", "종로/대학로", "홍대/마포"],
        "경기/인천": ["고양/파주", "구리/남양주", "김포/부천", "성남/분당", "수원/용인", "안산/시흥", "안양/과천", "의정부/동두천", "인천/강화", "일산/파주"],
        "대전/충청": ["대전 동구", "대전 서구", "대전 유성구", "대전 중구", "청주/충북", "천안/아산"],
        "대구/경북": ["대구 중구", "대구 동구", "대구 서구", "대구 남구", "대구 북구", "경북 포항", "경북 구미"],
        "부산/경남": ["부산 해운대", "부산 서면", "부산 남포동", "창원/마산", "김해/양산", "진주/사천"],
        "광주/전라": ["광주 동구", "광주 서구", "광주 남구", "광주 북구", "전주/익산", "목포/순천"],
        "강원": ["춘천/원주", "강릉/속초", "동해/삼척", "홍천/횡성"],
        "제주": ["제주시", "서귀포시", "애월/한림", "성산/우도"]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            CDHeaderWithLeftContent(){
                Button(action: {
                    dismiss()
                }) {
                    HStack(alignment: .center) {
                        Image("chevron_left")
                        
                        Text("카테고리")
                            .font(.t1)
                            .foregroundStyle(.gray9)
                    }
                }
            }
            
            CDTabSection(selectedTab: $selectedTab, data: categories)
                .padding(.top, 24)
            
            regionSelectSection
        }
    }
    
    private var regionSelectSection: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(0..<Array(regionData.keys).count, id: \.self) { index in
                    regionCategoryButton(index)
                }
                
                Spacer()
            }
            .frame(width: 120)
            .background(.gray1)
            
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(Array(regionData.keys.enumerated()), id: \.offset) { index, regionKey in
                                let isSelected = index == selectedRegion
                                VStack(spacing: 0) {
                                    HStack {
                                        Text(regionKey)
                                            .font(.m4r)
                                            .foregroundStyle(isSelected ? .white : .gray9)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(isSelected ? .mPink2 : .clear, in: RoundedRectangle(cornerRadius: 99))
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, isSelected ? 16 : 0)
                                    .padding(.top, 16)
                                    
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                                        ForEach(regionData[regionKey] ?? [], id: \.self) { region in
                                            regionDetailButton(region)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    if index != regionData.keys.count - 1 {
                                        Divider()
                                            .background(isSelected ? .mPink1 : .gray2)
                                            .padding(.top, 16)
                                    }
                                }
                                .id(regionStartIndex[index])
                            }
                        }
                    }
                    .onChange(of: selectedRegion) { _, newValue in
                        withAnimation(.fastEaseInOut) {
                            proxy.scrollTo(regionStartIndex[selectedRegion], anchor: .top)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
    }
    
    private func regionCategoryButton(_ index: Int) -> some View {
        Button(action: {
            selectedRegion = index
        }) {
            HStack {
                Text(Array(regionData.keys)[index])
                    .font(.m4r)
                    .foregroundStyle(selectedRegion == index ? .gray9 : .gray5)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .background(selectedRegion == index ? .white : .clear)
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
