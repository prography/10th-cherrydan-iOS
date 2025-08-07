import SwiftUI

struct KeywordNotificationRow: View {
    let notification: KeywordNotification
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // 선택 체크박스
            Button(action: onSelect) {
                Image("check_circle_\(isSelected ? "filled" : "empty")")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            // 알림 내용
            VStack(alignment: .leading, spacing: 4) {
                Text("\(notification.keyword) 캠페인이 등록되었어요. 지금 바로 확인해 보세요.")
                    .font(.m4r)
                    .foregroundColor(.gray9)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // 읽지 않은 알림 표시 및 화살표
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
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.white)
    }
}
