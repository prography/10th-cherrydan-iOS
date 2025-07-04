import SwiftUI

struct MyCampaignView: View {
    @State private var selectedTab = 1 // 신청 탭이 기본 선택
    @State private var isEditMode = false
    
    private let tabData = [
        ("전체", 2),
        ("신청", 3),
        ("선정", 2),
        ("등록", 1),
        ("종료", 1)
    ]
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDHeaderWithRightContent(title: "내 체험단"){
                Image("trash")
            }
            .padding(.horizontal, 16)
            
            tabSection
                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(spacing: 16) {
                    campaignListSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
            
            Spacer()
        }
    }
    
    private var tabSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 24) {
                ForEach(0..<tabData.count, id: \.self) { index in
                    tabItem(index)
                }
            }
            
            Divider()
                .background(.gray2)
        }
    }
    
    private var campaignListSection: some View {
        VStack(spacing: 16) {
            Divider()
            
            ForEach(MyCampaign.dummy.prefix(2), id: \.id) { campaign in
                MyCampaignRow(
                    myCampaign: campaign,
                    leftButtonTitle: campaign.statusLabel == "선정됨" ? "공고 확인" : nil,
                    rightButtonTitle: campaign.statusLabel == "선정됨" ? "방문 완료" : 
                                     campaign.statusLabel == "완료" ? "결과 확인" : "신청 취소",
                    isRightButtonPrimary: campaign.statusLabel == "완료",
                    isChecked: campaign.statusLabel == "완료",
                    onLeftButtonTap: {
                        // 왼쪽 버튼 액션
                    },
                    onRightButtonTap: {
                        // 오른쪽 버튼 액션
                    }
                )
                
                Divider()
            }
        }
    }
    
    private func tabItem(_ index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Text(tabData[index].0)
                        .font(.m4b)
                        .foregroundStyle(selectedTab == index ? .mPink3 : .gray5)
                    
                    Text("\(tabData[index].1)")
                        .font(.m4b)
                        .foregroundStyle(selectedTab == index ? .mPink3 : .gray5)
                }
                
                Rectangle()
                    .fill(selectedTab == index ? .mPink3 : .clear)
                    .frame(height: 2)
            }
        }
    }
}

#Preview {
    MyCampaignView()
} 
