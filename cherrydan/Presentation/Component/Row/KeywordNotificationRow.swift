import SwiftUI

struct KeywordNotificationRow: View {
    let notification: KeywordNotification
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Button(action: onSelect) {
                Image("check_circle_\(isSelected ? "filled" : "empty")")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
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
            
            HStack(spacing: 8) {
                if !notification.isRead {
                    Circle()
                        .fill(Color.mPink3)
                        .frame(width: 8, height: 8)
                }
                
                Image("chevron_right")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.gray4)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
    }
}
