import SwiftUI

struct ProfileSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedInterestAreas = ["강동구", "강남구", "송파구"]
    @State private var selectedInterestTopics = ["운동", "음식"]
    @State private var selectedKeywords = ["키워드", "키워드"]
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: "내 정보")
                .padding(.horizontal, 16)
            
            ScrollView(.vertical, showsIndicators: false) {
                infoList
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 120)
            }
        }
    }
    
    private var infoList: some View {
        VStack(alignment: .leading, spacing: 16) {
            infoRow(
                label: "이름",
                value: "하태린",
                isRequired: true
            )
            
            infoRow(
                label: "이메일",
                value: "goil1113@likelion.org",
                isRequired: true
            )
            
            tagSection(
                title: "관심 지역",
                tags: selectedInterestAreas,
                onRemove: { tag in
                    selectedInterestAreas.removeAll { $0 == tag }
                }
            )
            
            tagSection(
                title: "관심 주제",
                tags: selectedInterestTopics,
                onRemove: { tag in
                    selectedInterestTopics.removeAll { $0 == tag }
                }
            )
            
            tagSection(
                title: "관심 키워드",
                tags: selectedKeywords,
                onRemove: { tag in
                    selectedKeywords.removeAll { $0 == tag }
                }
            )
            
            infoRow(
                label: "연락처",
                value: "010-7728-6552"
            )
            
            contactInfoSection
            
            infoRow(
                label: "출생년도",
                value: "2000.01.10"
            )
        }
    }
    
    private var contactInfoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("주소")
                .font(.m5b)
                .foregroundStyle(.gray4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("05277")
                
                Text("서울특별시 강동구 고덕로80길 134 112동\n803호")
                    .lineLimit(2)
            }
            .font(.m2r)
            .foregroundStyle(.gray9)
            .padding(.vertical, 10)
            
            CDRoundButton("변경", type: .gray) {}
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 8)
            
            Divider()
        }
    }
    
    private func infoRow(
        label: String,
        value: String,
        isRequired: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                if isRequired {
                    Text("*")
                        .font(.m5b)
                        .foregroundStyle(.mPink3)
                }
                
                Text(label)
                    .font(.m5b)
                    .foregroundStyle(isRequired ? .mPink3 : .gray4)
            }
            
            Text(value)
                .font(.m2r)
                .foregroundStyle(.gray9)
                .frame(height:44, alignment: .center)
            
            Divider()
        }
    }
    
    private func tagSection(
        title: String,
        tags: [String],
        onRemove: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.m5b)
                .foregroundStyle(.gray4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(tags, id: \.self) { tag in
                        tagButton(tag, onRemove: { onRemove(tag) })
                    }
                    
                    CDRoundButton("추가", type: .primary) {}
                }
                .padding(.vertical, 10)
            }
            .padding(.bottom, 4)
            
            Divider()
        }
    }
    

    private func tagButton(
        _ title: String,
        onRemove: @escaping () -> Void
    ) -> some View {
        Button(action: onRemove) {
            HStack(spacing: 4) {
                Text("\(title) X")
                    .font(.m5r)
                    .foregroundStyle(.gray9)
            }
            .padding(.horizontal, 12)
            .padding(.top, 6)
            .padding(.bottom, 8)
            
            .background(.pBlue, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    ProfileSettingView()
}
