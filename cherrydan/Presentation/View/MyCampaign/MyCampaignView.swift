import SwiftUI

struct MyCampaignView: View {
//    @State private var selectedTab = 1 // 신청 탭이 기본 선택
    @State private var isEditPresent = false
    @StateObject private var viewModel = MyCampaignViewModel()
//    private let tabData = [
//        ("찜", 2),
//        ("신청", 3),
//        ("선정", 2),
//        ("등록", 1),
//        ("종료", 1)
//    ]
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDHeaderWithRightContent(title: "내 체험단"){
                Image("trash")
            }
            .padding(.horizontal, 16)
            
//            tabSection
//                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    campaignListSection
                }
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
            
            Spacer()
        }
    }
    
//    private var tabSection: some View {
//        VStack(spacing: 0) {
//            HStack(spacing: 24) {
//                ForEach(0..<tabData.count, id: \.self) { index in
//                    tabItem(index)
//                }
//            }
//            
//            Divider()
//                .background(.gray2)
//        }
//    }
    
    private var campaignListSection: some View {
        VStack(spacing: 16) {
            Divider()
                .padding(.horizontal, 16)
            
            ForEach(viewModel.likedCampaigns, id: \.id) { campaign in
                MyCampaignRow(
                    myCampaign: campaign
                )
                
                Divider()
            }
            .padding(.horizontal, 16)
            closedSection
        }
    }
    
    private var closedSection: some View {
        HStack{
            Text("신청 마감된 공고")
                .frame(maxWidth: .infinity ,alignment: .leading)
            Image("chevron_right")
        }
        .padding(.horizontal, 16)
        .frame(height: 80, alignment: .center)
        .background(.gray1)
    }
//    private func tabItem(_ index: Int) -> some View {
//        Button(action: {
//            selectedTab = index
//        }) {
//            VStack(spacing: 8) {
//                HStack(spacing: 4) {
//                    Text(tabData[index].0)
//                        .font(.m4b)
//                        .foregroundStyle(selectedTab == index ? .mPink3 : .gray5)
//                    
//                    Text("\(tabData[index].1)")
//                        .font(.m4b)
//                        .foregroundStyle(selectedTab == index ? .mPink3 : .gray5)
//                }
//                
//                Rectangle()
//                    .fill(selectedTab == index ? .mPink3 : .clear)
//                    .frame(height: 2)
//            }
//        }
//    }
}

#Preview {
    MyCampaignView()
} 
