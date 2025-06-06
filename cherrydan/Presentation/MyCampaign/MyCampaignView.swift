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
        VStack(spacing: 0) {
            CDHeaderWithLeftContent(){
                Text("내 체험단")
                    .font(.t1)
                    .foregroundStyle(.gray9)
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
        .background(.white)
        .hideTabBar()
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
            campaignCard(
                status: "신청 마감 6일 전",
                title: "[외모미] 알로에베 10kg 감량 가능! 정말 믿을때 빠지고! 성공율 초초 높수 체험",
                platform: .youtube,
                reviewPlatform: "레뷰",
                leftButtonTitle: "신청 취소",
                rightButtonTitle: "신청 취소",
                isRightButtonPrimary: false
            )
            
            campaignCard(
                status: "신청 마감 6일",
                title: "[외모미] 알로에베 10kg 감량 가능! 정말 믿을때 빠지고! 성공율 초초 높수 체험",
                platform: .youtube,
                reviewPlatform: "레뷰",
                leftButtonTitle: nil,
                rightButtonTitle: "결과 확인",
                isRightButtonPrimary: true
            )
            
            campaignCard(
                status: "신청 마감 6일 전",
                title: "[외모미] 알로에베 10kg 감량 가능! 정말 믿을때 빠지고! 성공율 초초 높수 체험",
                platform: .youtube,
                reviewPlatform: "레뷰",
                leftButtonTitle: nil,
                rightButtonTitle: nil,
                isRightButtonPrimary: false
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
    
    private func campaignCard(
        status: String,
        title: String,
        platform: SocialPlatform,
        reviewPlatform: String,
        leftButtonTitle: String?,
        rightButtonTitle: String?,
        isRightButtonPrimary: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // 캠페인 이미지
                AsyncImage(url: URL(string: "https://picsum.photos/200")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            ProgressView()
                        )
                }
                .frame(width: 80, height: 80)
                .cornerRadius(4)
                
                VStack(alignment: .leading, spacing: 8) {
                    // 상태
                    Text(status)
                        .font(.m5b)
                        .foregroundStyle(.mPink3)
                    
                    // 제목
                    Text(title)
                        .font(.m5r)
                        .foregroundStyle(.gray9)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // 플랫폼 정보
                    VStack(alignment: .leading, spacing: 4) {
                        Text("플랫폼: 1박스")
                            .font(.m6r)
                            .foregroundStyle(.gray5)
                        
                        Text("신청 175/5명")
                            .font(.m6r)
                            .foregroundStyle(.gray5)
                        
                        HStack(spacing: 4) {
                            Image(platform.imageName)
                                .frame(width: 16, height: 16)
                            
                            Text(platform.displayName)
                                .font(.m6r)
                                .foregroundStyle(.gray9)
                            
                            Image("review")
                                .frame(width: 16, height: 16)
                            
                            Text(reviewPlatform)
                                .font(.m6r)
                                .foregroundStyle(.gray9)
                        }
                    }
                }
                
                Spacer()
            }
            
            // 버튼 섹션
            if leftButtonTitle != nil || rightButtonTitle != nil {
                HStack(spacing: 8) {
                    if let leftButtonTitle = leftButtonTitle {
                        CHSmallButton(leftButtonTitle, isMinor: true) {
                            // 왼쪽 버튼 액션
                        }
                    }
                    
                    Spacer()
                    
                    if let rightButtonTitle = rightButtonTitle {
                        CHSmallButton(rightButtonTitle, isMinor: !isRightButtonPrimary) {
                            // 오른쪽 버튼 액션
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    MyCampaignView()
} 
