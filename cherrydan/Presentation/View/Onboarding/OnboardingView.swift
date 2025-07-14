import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @StateObject var viewModel = OnboardingViewModel()
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                HStack(alignment:.center, spacing: 16) {
                    Image("logo_white")
                    
                    Text("체험단\n리뷰 쓰는\n사람들")
                        .font(.t1)
                        .foregroundStyle(.gray9)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(spacing: 24) {
                    Text("SNS 계정으로 시작하기")
                        .font(.m4r)
                        .foregroundStyle(.gray9)
                    
                    VStack(spacing: 8) {
                        socialButton(.kakao)
                        socialButton(.naver)
                        
                        appleButton
                        socialButton(.google)
                    }
                    
                    Button(action: {
                        AuthManager.shared.enterGuestMode()
                    }){
                        Text("게스트모드로 시작하기")
                            .font(.m4r)
                            .foregroundStyle(.mPink2)
                            .underline(.mPink2)
                    }
                }
            }
            .padding(.top, 280)
            .padding(.bottom, 80)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity,alignment: .center)
            .background(.pBeige)
            
            // 로딩 오버레이
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    
                    Text("로그인 중...")
                        .font(.m3r)
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    private func socialButton(_ platform: LoginPlatform) -> some View {
        Button(action: {
            Task {
                switch platform {
                case .kakao:
                    await viewModel.performKakaoLogin()
                case .naver:
                    await viewModel.performNaverLogin()
                case .google:
                    viewModel.performGoogleLogIn()
                    break
                case .apple:
                    // 애플 로그인은 별도 버튼으로 처리
                    break
                }
            }
        }) {
            ZStack {
                HStack {
                    Image("\(platform.rawValue)-login")
                        .padding(12)
                    
                    Spacer()
                }
                
                Text("\(platform.title)로 로그인")
                    .font(.m3r)
                    .foregroundStyle(.gray9)
                
                if viewModel.recentLoggedInPlatform == platform {
                    HStack {
                        Spacer()
                        
                        Image("recent")
                            .offset(y: -24)
                            .padding(.trailing, 16)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 48)
            .background(platform.backgroundColor, in: RoundedRectangle(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(platform == .google ? .gray3 : .clear, lineWidth: 1)
            )
        }
    }
    
    private var appleButton: some View {
        ZStack {
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        Task {
                            await viewModel.performAppleLogin(authorization)
                        }
                    case .failure(let error):
                        viewModel.errorMessage = "애플 로그인 실패: \(error.localizedDescription)"
                    }
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .cornerRadius(8)
            
            if viewModel.recentLoggedInPlatform == .apple {
                HStack {
                    Spacer()
                    
                    Image("recent")
                        .offset(y: -24)
                        .padding(.trailing, 16)
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
