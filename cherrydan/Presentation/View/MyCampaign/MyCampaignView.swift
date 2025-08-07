import SwiftUI

struct MyCampaignView: View {
//    @State private var selectedTab = 1 // 신청 탭이 기본 선택
    @State private var isEditPresent = false
    @StateObject private var viewModel = MyCampaignViewModel()
    private let tabData = [
        ("찜한 공고", 2),
//        ("신청", 3),
//        ("선정", 2),
//        ("등록", 1),
//        ("종료", 1)
    ]
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDHeaderWithRightContent(title: "내 체험단"){}
                .padding(.horizontal, 16)
            
            //            tabSection
            //                .padding(.horizontal, 16)
            Text("찜한 공고")
                .font(.m3b)
                .foregroundStyle(.mPink3)
                .padding(16)
            
            if !viewModel.isShowingClosedCampaigns {
                if viewModel.likedCampaigns.isEmpty {
                    openSectionPlaceholder
                } else {
                    openSection
                }
            } else {
                closedCampaignListSection
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.mediumSpring, value: viewModel.isShowingClosedCampaigns)
    }
    
    private var openSectionPlaceholder: some View {
        VStack(spacing: 12) {
            Text("찜한 공고 중 신청 가능한 공고가 없어요")
                .font(.m4r)
                .foregroundStyle(.gray5)
                .padding(.vertical, 120)
        }
    }
    
    private var openSection: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.likedCampaigns, id: \.id) { campaign in
                    MyCampaignRow(
                        myCampaign: campaign,
                        buttonConfigs: [
                            ButtonConfig(
                                text: "공고 보기",
                                type: .smallGray,
                                onClick: {
                                    print("공고 보기: \(campaign.campaignTitle)")
                                }
                            )
                        ]
                    )
                    
                    Divider()
                }
            }
            .padding(.horizontal, 16)
            
            closedSectionButton
        }
        .transition(.move(edge: .leading))
    }
    
    private var closedSectionButton: some View {
        Button(action: {
            viewModel.isShowingClosedCampaigns = true
        }) {
            HStack{
                Text("신청 마감된 공고")
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .font(.m3b)
                    .foregroundStyle(.gray5)
                
                Image("chevron_right")
            }
            .padding(.horizontal, 16)
            .frame(height: 80, alignment: .center)
            .background(.gray1)
        }
    }
    
    private var closedCampaignListSection: some View {
        VStack(spacing: 0) {
            Button(action: {
                    viewModel.isShowingClosedCampaigns = false
            }) {
                HStack(spacing: 0) {
                    Image("chevron_left")
                    Text("신청 마감된 공고")
                        .font(.m3b)
                        .foregroundStyle(.gray9)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            
            if viewModel.likedClosedCampaigns.isEmpty {
                closedSectionPlaceholder
            } else {
                closedSection
            }
        }
        .background(.gray1)
    }
    
    private var closedSectionPlaceholder: some View {
        VStack(spacing: 12) {
            Text("마감된 공고가 없습니다")
                .font(.m4r)
                .foregroundStyle(.gray5)
                .padding(.vertical, 120)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var closedSection: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                ForEach(viewModel.likedClosedCampaigns, id: \.id) { campaign in
                    MyCampaignRow(
                        myCampaign: campaign,
                        buttonConfigs: [
                            ButtonConfig(
                                text: "공고 확인하기",
                                type: .smallWhite,
                                onClick: {
                                    print("공고 확인하기: \(campaign.campaignTitle)")
                                }
                            )
                        ]
                    )
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
