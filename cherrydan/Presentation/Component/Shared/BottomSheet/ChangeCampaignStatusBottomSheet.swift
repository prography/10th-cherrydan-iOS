import SwiftUI

struct ChangeCampaignStatusBottomSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresented: Bool
    @Binding var selectedStatus: CampaignStatusType?
    
    let onStatusSelected: (CampaignStatusType) -> Void
    
    var body: some View {
        CDBottomSheet(type: .titleCenter(title: "해당 공고의 상태를 선택해 주세요.", buttonConfig: nil)) {
            VStack(spacing: 0) {
                HStack(spacing: 8) {
                    ForEach(CampaignStatusType.allCases, id: \.self) { status in
                        statusOptionItem(status)
                    }
                }
                .padding(.bottom, 36)
                
                HStack(spacing: 8) {
                    CDButton(text: "취소", type: .middlePrimary, action: { dismiss() })
                    
                    CDButton(text: "완료", type: .largePrimary, isDisabled: selectedStatus == nil) {
                        if let selectedStatus = selectedStatus {
                            onStatusSelected(selectedStatus)
                            dismiss()
                        }
                    }
                    .disabled(selectedStatus == nil)
                }
            }
        }
    }
    
    private func statusOptionItem(_ status: CampaignStatusType) -> some View {
        Button(action: {
            selectedStatus = status
        }) {
            let isSelected = selectedStatus == status
            
            Text(status.displayName)
                .font(.m3r)
                .foregroundStyle(isSelected ? .gray0 : .gray5)
                .frame(width: 62, height: 62)
                .background(isSelected ? .mPink3 : .gray2, in: Circle())
        }
    }
}

extension CampaignStatusType {
    
}
