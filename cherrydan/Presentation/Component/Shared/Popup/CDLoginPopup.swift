import SwiftUI

struct CDLoginPopup: View {
    @Environment(\.dismiss) private var dismiss
    let email: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("이미 가입된 계정이 있습니다.\n로그인 해주세요.")
                .font(.m1b)
                .multilineTextAlignment(.center)
            
            Text(email)
                .font(.m3r)
                .foregroundStyle(.gray9)
                .padding(16)
                .frame(maxWidth: .infinity, alignment:.leading)
                .background(.gray0, in: RoundedRectangle(cornerRadius: 4))
                .padding(.bottom, 20)
                
            CDButton(text: "확인") { dismiss() }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(.pBeige, in: RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 16)
    }
}

#Preview {
    ZStack {
        Color.black
            .edgesIgnoringSafeArea(.all)
            .opacity(0.3)
        
        CDLoginPopup(email:"asdf")
    }
}
