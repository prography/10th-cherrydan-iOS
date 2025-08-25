import SwiftUI

struct CDSelectSection: View {
    @Binding var isDeleteMode: Bool
    let toggleSelectAll: () -> Void
    let rightButtonText: String
    let onRightButtonClick: () -> Void
    let onClickDelete: () -> Void
    let isAllSelected: Bool
    let isSelectionValid: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: { toggleSelectAll() }) {
                HStack(spacing: 2){
                    Image("check_circle_\(isAllSelected ? "filled" : "empty")")
                    
                    Text("모두 선택")
                        .font(.m4r)
                        .foregroundColor(.gray9)
                }
            }
            
            Spacer()
            
            if isDeleteMode {
                HStack(spacing: 4){
                    Button(action: { onClickDelete() }) {
                        Text("삭제")
                            .font(.m4b)
                            .foregroundColor(isSelectionValid ? .mPink3 : .gray5)
                    }
                    .disabled(!isSelectionValid)
                    
                    Rectangle()
                        .fill(.gray4)
                        .frame(width: 1, height: 12)
                    
                    Button(action: {
                        isDeleteMode = false
                    }) {
                        Text("취소")
                            .foregroundColor(.gray9)
                            .font(.m4b)
                    }
                }
            } else {
                Button(action: { onRightButtonClick() }) {
                    Text(rightButtonText)
                }
                .font(isSelectionValid ? .m4b : .m4r)
                .foregroundColor(isSelectionValid ? .mPink3 : .gray5)
                .disabled(!isSelectionValid)
                
            }
        }
        .frame(height: 32)
    }
}
