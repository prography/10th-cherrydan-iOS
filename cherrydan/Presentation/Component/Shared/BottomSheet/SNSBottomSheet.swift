import SwiftUI

struct SNSBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var platformUrl: String = ""
    
    let platformType: SocialPlatformType
    let onConnect: (String) -> Void
    
    var body: some View {
        CDBottomSheet(
            type: .titleLeading(title: platformType.connectGuideTitle, buttonConfig: ButtonConfig(
                text: platformType.connectButtonText,
                disabled: platformUrl.isEmpty,
                onClick: {
                    onConnect(platformUrl)
                    dismiss()
                }
            )),
            height: 380,
            horizontalPadding: 16
        ) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(platformType.connectGuideMessages.enumerated()), id: \.offset) { index, message in
                        guideMessageView(message: message)
                    }
                }
                
                // 온라인 허가 텍스트
                HStack {
                    Text("1.1 온라인허가")
                        .font(.m5r)
                        .foregroundStyle(.red)
                    Spacer()
                }
                
                // URL 입력 섹션
                VStack(alignment: .leading, spacing: 8) {
                    TextField(platformType.urlPlaceholder, text: $platformUrl)
                        .font(.m4r)
                        .foregroundStyle(.gray9)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.gray1, in: RoundedRectangle(cornerRadius: 4))
                        .textInputAutocapitalization(.never)
                        .keyboardType(.URL)
                }
                
                Spacer()
            }
        }
    }
    
    private func guideMessageView(message: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.m4r)
                .foregroundStyle(.gray9)
                .frame(width: 10, alignment: .leading)
            
            Text(message)
                .font(.m4r)
                .foregroundStyle(.gray9)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

#Preview {
    SNSBottomSheet(
        platformType: .youtube,
        onConnect: { _ in }
    )
} 
