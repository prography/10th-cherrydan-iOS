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
        CHScreen {
            CDHeaderWithRightContent(title: "내 체험단"){
                Image("trash")
            }
            
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
            
            CampaignRow(
                status: "신청 마감 6일 전",
                title: "[외모미] 알로에베 10kg 감량 가능! 정말 믿을때 빠지고! 성공율 초초 높수 체험",
                platform: .youtube,
                reviewPlatform: .revu,
                leftButtonTitle: "공고 확인",
                rightButtonTitle: "방문 완료",
                isRightButtonPrimary: false,
                isChecked: false,
                onLeftButtonTap: {
                    // 왼쪽 버튼 액션
                },
                onRightButtonTap: {
                    // 오른쪽 버튼 액션
                }
            )
            
            Divider()
            
            CampaignRow(
                status: "신청 마감 6일",
                title: "[외모미] 알로에베 10kg 감량 가능! 정말 믿을때 빠지고! 성공율 초초 높수 체험",
                platform: .youtube,
                reviewPlatform: .revu,
                rightButtonTitle: "결과 확인",
                isRightButtonPrimary: true,
                isChecked: true,
                onRightButtonTap: {
                    // 오른쪽 버튼 액션
                }
            )
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
