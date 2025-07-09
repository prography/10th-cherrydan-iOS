import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var router: MyPageRouter
    @StateObject private var viewModel = MyPageViewModel()
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDHeaderWithLeftContent(
                onNotificationClick: {
                    router.push(to: .notification)
                }, onSearchClick: {
                    router.push(to: .search)
                }){
                    Text("마이페이지")
                        .font(.t1)
                        .foregroundStyle(.gray9)
                }
                .padding(.top, 6)
                .padding(.horizontal, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    profileSection
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
    
    private var profileSection: some View {
        Text("\(viewModel.user.name)님 안녕하세요")
            .font(.t4)
            .foregroundStyle(.gray9)
    }
    
    private var menuSection: some View {
        VStack(alignment: .leading, spacing: 0) {
//            Text("내 정보 관리")
//                .foregroundStyle(.mPink2)
//                .font(.m5b)
//            
//            if let user = viewModel.user {
//                Text(user.name)
//            }
//            
//            menuItem("내 정보") {
//                router.push(to: .profileSetting)
//            }
//            menuItem("SNS 연결") {
//                router.push(to: .manageSNS)
//            }
//            menuItem("체험단 연결"){
//                router.push(to: .mediaConnect)
//            }
//            
//            Divider()
//                .padding(.top, 4)
//                .padding(.bottom, 16)
//            
//            Text("환경 설정")
//                .foregroundStyle(.mPink2)
//                .font(.m5b)
//            
//            menuItem("알림 설정") {
//                
//            }
            
//            Divider()
//                .padding(.top, 4)
//                .padding(.bottom, 16)
            
            Text("고객 센터")
                .foregroundStyle(.mPink2)
                .font(.m5b)
            HStack {
                Text("버전 정보")
                    .font(.m3r)
                    .foregroundStyle(.gray9)
                
                Spacer()
                
                Text(viewModel.version)
                    .font(.m3b)
                    .foregroundStyle(.gray5)
            }
            .padding(.vertical, 8)
            
            menuItem("개인정보 처리방침") {}
            menuItem("이용약관") {
                router.push(to: .agreement)
            }
            menuItem("운영정책") {}
        }
    }
    
    private var bottomButtonSection: some View {
        HStack(spacing: 8) {
            Spacer()
            
            Button(action: {
                router.push(to: .withdrawal)
            }) {
                Text("회원 탈퇴")
                    .font(.m5r)
                    .foregroundStyle(.gray5)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.gray1)
                    .cornerRadius(2)
            }
            
            Button(action: {
                AuthManager.shared.logout()
            }) {
                Text("로그아웃")
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
