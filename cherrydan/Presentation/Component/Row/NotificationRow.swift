import SwiftUI

struct NotificationRow: View {
    let notification: ActivityNotification
    let isSelected: Bool
    let onSelect: (() -> Void)
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onSelect) {
                Image("check_circle_\(isSelected ? "filled" : "empty")")
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 0) {
                    Text("방문알림")
                        .font(.m5b)
                        .foregroundColor(.gray5)
                    
                    Spacer()
                    
                    if !notification.isRead {
                        Circle()
                            .fill(.mPink2)
                            .frame(width: 8, height: 8)
                            .padding(.leading, 4)
                    }
                }
                
                (
                    Text(notification.campaignTitle)
                        .font(.m5b)
                        .foregroundColor(.gray9)
                    +
                    Text(" 방문일이 \(notification.dday)일 남았습니다.")
                        .font(.m5r)
                        .foregroundColor(.gray9)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(notification.alertDate)
                    .font(.m5r)
                    .foregroundColor(.gray4)
            }
        }
        .padding(.vertical, 16)
    }
}
