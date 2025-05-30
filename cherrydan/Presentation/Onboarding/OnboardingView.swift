import SwiftUI

struct OnboardingView: View {
    
    var body: some View {
        VStack(spacing: 40) {
            HStack(alignment:.center, spacing: 16) {
                Image("logo_white")
                
                Text("체험단\n리뷰 쓰는\n사람들")
                    .font(.t1)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            VStack(spacing: 24) {
                Text("SNS 계정으로 간편 가입하기")
                    .font(.m3r)
                    .foregroundStyle(.gray9)
                
                HStack(spacing: 4) {
                    socialButton("kakao")
                    socialButton("naver")
                    socialButton("apple")
                    socialButton("google")
                }
            }
        }
        .padding(.top, 280)
        .padding(.bottom, 80)
        .frame(maxWidth: .infinity,alignment: .center)
        .background(.pBeige)
    }
    
    private func socialButton(_ platform: String) -> some View {
        Button(action: {
            // 소셜 로그인 액션
        }) {
            Image("\(platform)_login")
        }
    }
}

#Preview {
    OnboardingView()
}
