import SwiftUI

struct NoticeBoardRow: View {
    let notice: Notice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                if let label = notice.type.label {
                    Text(label)
                        .font(.m5r)
                        .foregroundColor(notice.type.labelTextColor)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(notice.type.labelBackgroundColor, in:RoundedRectangle(cornerRadius: 4))
                }
                
                Text("운영자 " + notice.date)
                    .font(.m5r)
                    .foregroundColor(.gray5)
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text(notice.title)
                    .font(.m3b)
                    .foregroundColor(.gray9)
                
                Text(notice.content)
                    .font(.m5r)
                    .lineSpacing(2)
                    .foregroundColor(.gray5)
                    .lineLimit(2)
            }
            
            HStack(spacing: 4) {
                HStack(spacing: 0) {
                    Image("eye")
                    Text("조회 \(notice.views)")
                        .font(.m5r)
                        .foregroundColor(.gray5)
                }
                
                HStack(spacing: 0) {
                    Image("heart")
                    Text("공감 \(notice.likes)")
                        .font(.m5r)
                        .foregroundColor(.gray5)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 16)
    }
}
