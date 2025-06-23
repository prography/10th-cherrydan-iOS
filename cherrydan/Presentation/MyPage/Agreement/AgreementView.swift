import SwiftUI

struct AgreementView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isChecked = true
    
    var body: some View {
        CHScreen {
            CDHeaderWithLeftContent(){
                Button(action: {
                    dismiss()
                }) {
                    HStack(alignment: .center) {
                        Image("chevron_left")
                        
                        Text("약관 및 이용 동의")
                            .font(.t1)
                            .foregroundStyle(.gray9)
                    }
                }
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    receivingAgreementSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 120)
            }
            
            Spacer()
        }
        .background(.gray1)
    }
    
    private var receivingAgreementSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("수신 동의")
                    .font(.m3b)
                    .foregroundStyle(.gray9)
                
                Text("체리단에서 진행하는 다양한 이벤트의 회원 혜택을 제공할 추천 등 다양한 혜택을 안내드려요.")
                    .font(.m5r)
                    .foregroundStyle(.gray4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Button(action:{
                    isChecked.toggle()
                }){
                    HStack(spacing: 4) {
                        Image("check_circle\(isChecked ? "_filled":"")")
                        
                        Text("이벤트 및 캠페인 추천 등 혜택 안내를 위한 개인정보 수집 • 이용동의(선택)")
                            .font(.m5r)
                            .foregroundStyle(.gray9)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                VStack(alignment: .leading) {
                    detailSection
                    
                    Text("이벤트 및 캠페인 추천 등 혜택 안내 수신 동의")
                        .font(.m5r)
                        .foregroundStyle(.gray9)
                        .multilineTextAlignment(.leading)
                    
                    detailSection
                    
                    HStack(spacing: 24) {
                        smallCheckBox("푸시 알림"){}
                        smallCheckBox("이메일"){}
                        smallCheckBox("SMS"){}
                       
                    }
                }
                .padding(.leading, 28)
                
            }
        }
    }
    
    private var detailSection: some View {
        Text("상세")
            .font(.m5r)
            .foregroundStyle(.mPink2)
            .underline(.mPink2)
            .padding(.bottom, 12)
    }
    
    private func smallCheckBox(
        _ title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 0){
                Image("check_circle\(isChecked ? "_filled":"")")
                
                Text(title)
                    .font(.m5r)
                    .foregroundStyle(.gray9)
            }
        }
    }
}

#Preview {
    AgreementView()
} 
