import SwiftUI

struct NotificationRow: View {
    let notification: ActivityNotification
    let isSelected: Bool
    let onSelect: (() -> Void)?
    
    init(
        notification: ActivityNotification,
        isSelected: Bool = false,
        onSelect: (() -> Void)? = nil
    ) {
        self.notification = notification
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let onSelect = onSelect {
                Button(action: onSelect) {
                    Image("check_circle_\(isSelected ? "_filled" : "_empty")")
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text(notification.notificationType)
                        .font(.m4b)
                        .foregroundColor(.gray9)
                    
                    if !notification.isRead {
                        Circle()
                            .fill(Color.mPink2)
                            .frame(width: 7, height: 7)
                            .padding(.leading, 4)
                    }
                }
                
                Text(notification.notificationBoldText)
                    .font(.m4b)
                    .foregroundColor(.gray9)
                
                boldTextInFullText()
                    .foregroundColor(.gray9)
                    .lineLimit(2)
                
                Text(notification.createdDate)
                    .font(.m5r)
                    .foregroundColor(.gray4)
            }
            
            Spacer()
        }
        .padding(.vertical, 16)
    }
    
    @ViewBuilder
    private func boldTextInFullText() -> some View {
        let fullText = notification.fullText
        let boldText = notification.notificationBoldText
        
        if let range = fullText.range(of: boldText) {
            let beforeBold = String(fullText[..<range.lowerBound])
            let afterBold = String(fullText[range.upperBound...])
            
            HStack(spacing: 0) {
                if !beforeBold.isEmpty {
                    Text(beforeBold)
                        .font(.m5b)
                }
                
                Text(boldText)
                    .font(.m4b)
                
                if !afterBold.isEmpty {
                    Text(afterBold)
                        .font(.m5r)
                }
            }
        } else {
            Text(fullText)
                .font(.m4r)
        }
    }
}
