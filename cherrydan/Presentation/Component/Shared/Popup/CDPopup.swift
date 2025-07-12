import SwiftUI

struct CDPopup: View {
    let hidePopup: () -> Void
    let type: PopupType
    
    var body: some View {
        let config = type.config
        
        VStack(spacing: 4) {
            if let image = config.image, !image.isEmpty {
                Image(image)
                    .padding(.bottom, 8)
            } else {
                Spacer().frame(height: 8)
            }
            
            Text(config.title)
                .font(.t2)
                .foregroundColor(.gray9)
            
            Text(config.description)
                .font(.t5)
                .foregroundColor(.gray5)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            buttonSection
        }
        .padding(16)
        .background(.pBeige, in: RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var buttonSection: some View {
        let config = type.config
        
        switch config.buttonLayout {
        case .horizontal:
            HStack(spacing: 4) {
                ForEach(Array(config.buttons.enumerated()), id: \.offset) { index, buttonConfig in
                    CDButton(
                        text: buttonConfig.text,
                        type: buttonConfig.type
                    ) {
                        buttonConfig.onClick()
                        hidePopup()
                    }
                }
            }
        case .vertical:
            VStack(spacing: 8) {
                ForEach(Array(config.buttons.enumerated()), id: \.offset) { index, buttonConfig in
                    CDButton(
                        text: buttonConfig.text,
                        type: buttonConfig.type
                    ) {
                        buttonConfig.onClick()
                        hidePopup()
                    }
                }
            }
        }
    }
}

#Preview {
    Preview_wrapper()
}

struct Preview_wrapper: View {
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
            
            CDPopup(
                hidePopup: {},
                type: .updateOptional(){}
            )
        }
    }
} 
