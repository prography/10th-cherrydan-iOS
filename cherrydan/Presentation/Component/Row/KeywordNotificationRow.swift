import SwiftUI

struct KeywordNotificationRow: View {
    let notification: KeywordNotification
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            Button(action: onSelect) {
                Image("check_circle_\(isSelected ? "filled" : "empty")")
            }
            
            VStack(alignment: .leading, spacing: 4) {
                (
                    Text(notification.keyword)
                        .font(.m5b)
                    +
                    Text(" 캠페인이 등록되었어요. 지금 바로 확인해 보세요.")
                        .font(.m5r)
                )
                .foregroundColor(.gray9)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(notification.alertDate)
                    .font(.m5r)
                    .foregroundColor(.gray4)
            }
            
            if !notification.isRead {
                Circle()
                    .fill(.mPink3)
                    .frame(width: 8, height: 8)
                    .padding(.leading, 4)
            }
            
            Image("chevron_right")
            
        }
        .padding(.vertical, 8)
    }
}
