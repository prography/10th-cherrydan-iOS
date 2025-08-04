struct ButtonConfig {
    let text: String
    let type: ButtonType
    let onClick: () -> Void
    let disabled: Bool
    
    init(
        text: String,
        type: ButtonType = .largePrimary,
        disabled: Bool = false,
        onClick: @escaping () -> Void
    ) {
        self.text = text
        self.type = type
        self.disabled = disabled
        self.onClick = onClick
    }
}
