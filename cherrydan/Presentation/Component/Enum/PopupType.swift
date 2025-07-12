import SwiftUI

enum PopupType {
    case updateMandatory(onClick:() -> Void)
    case updateOptional(onClick:() -> Void)
    case loginNeeded(onClick:() -> Void)
    case custom(PopupConfig)
    
    var config: PopupConfig {
        switch self {
        case .updateMandatory(let onClick):
            PopupConfig(
                image: nil,
                title: "새로운 버전 안내",
                description: "더 나은 서비스 제공을 위해\n새로운 기능과 개선사항이 추가되었어요",
                isOptional: false,
                buttons: [
                    ButtonConfig(text: "지금 업데이트하기", type: .largePrimary, onClick: onClick)
                ],
                buttonLayout: .horizontal
            )
        case .updateOptional(let onClick):
            PopupConfig(
                image: nil,
                title: "새로운 버전 안내",
                description: "더 나은 서비스 제공을 위해\n새로운 기능과 개선사항이 추가되었어요",
                isOptional: true,
                buttons: [
                    ButtonConfig(text: "닫기", type: .largeGray, onClick: {}),
                    ButtonConfig(text: "업데이트하기", type: .largePrimary, onClick: onClick)
                ],
                buttonLayout: .horizontal
            )
        case .loginNeeded(let onClick):
            PopupConfig(
                image: nil,
                title: "로그인 필요",
                description: "로그인이 필요한 기능입니다!",
                isOptional: true,
                buttons: [
                    ButtonConfig(text: "닫기", type: .largeGray, onClick: {}),
                    ButtonConfig(text: "로그인", type: .largePrimary, onClick: onClick)
                ],
                buttonLayout: .horizontal
            )
        case .custom(let config):
            config
        }
    }
}

struct PopupConfig {
    let image: String?
    let title: String
    let description: String
    let isOptional: Bool
    let buttons: [ButtonConfig]
    let buttonLayout: ButtonLayout
    
    init(
        image: String? = nil,
        title: String,
        description: String,
        isOptional: Bool = true,
        buttons: [ButtonConfig],
        buttonLayout: ButtonLayout = .vertical
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.isOptional = isOptional
        self.buttons = buttons
        self.buttonLayout = buttonLayout
    }
}

enum ButtonLayout {
    case vertical
    case horizontal
}
