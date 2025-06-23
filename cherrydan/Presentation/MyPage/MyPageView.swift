import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var router: MyPageRouter
    
    var body: some View {
        CHScreen {
            CDHeaderWithLeftContent(){
                Text("마이페이지")
                    .font(.t1)
                    .foregroundStyle(.gray9)
            }
            .padding(.top, 6)
            
            ScrollView {
                VStack(alignment: .trailing) {
                    menuSection
                    
                    bottomButtonSection
                }
                .padding(.top, 24)
                .padding(.bottom, 120)
                .padding(.horizontal, 16)
            }
            
            Spacer()
        }   
    }
    
    private var menuSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("내 정보 관리")
                .foregroundStyle(.mPink2)
                .font(.m5b)
            
            menuItem("내 정보") {
                router.push(to: .profileSetting)
            }
            menuItem("SNS 연결") {
                
            }
            menuItem("체험단 연결"){
                router.push(to: .mediaConnect)
            }
            
            Divider()
                .padding(.top, 4)
                .padding(.bottom, 16)
            
            Text("환경 설정")
                .foregroundStyle(.mPink2)
                .font(.m5b)
            
            menuItem("알림 설정") {
                
            }
            
            Divider()
                .padding(.top, 4)
                .padding(.bottom, 16)
            
            Text("고객 센터")
                .foregroundStyle(.mPink2)
                .font(.m5b)
            
            menuItem("자주 묻는 질문") {}
            menuItem("이용 가이드") {}
            menuItem("약관 및 이용 동의") {
                router.push(to: .agreement)
            }
            
            Divider()
                .padding(.top, 4)
                .padding(.bottom, 16)
        }
    }
    
    private var bottomButtonSection: some View {
        HStack(spacing: 8) {
            Button(action: {}) {
                Text("로그아웃")
                    .font(.m5r)
                    .foregroundStyle(.gray5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.gray1)
                    .cornerRadius(2)
            }
            
            Button(action: {}) {
                Text("회원 탈퇴")
                    .font(.m5r)
                    .foregroundStyle(.gray5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.gray1)
                    .cornerRadius(2)
            }
        }
    }
    
    private func menuItem(
        _ title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.m3r)
                .foregroundStyle(.gray9)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(MyPageRouter())
}
