import SwiftUI

struct NoticeDetailView: View {
    let noticeId: String
    @State private var notice: Notice?
    @State private var isLoading: Bool = true
    
    private let noticeBoardRepository = NoticeBoardRepository()
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title: "공지사항")
                .padding(.horizontal, 16)
            
            if isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("공지사항을 불러오는 중...")
                        .font(.m4r)
                        .foregroundColor(.gray5)
                        .padding(.top, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let notice = notice {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 헤더 정보
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                if let label = notice.type.label {
                                    Text(label)
                                        .font(.m5r)
                                        .foregroundColor(notice.type.labelTextColor)
                                        .padding(.vertical, 2)
                                        .padding(.horizontal, 8)
                                        .background(notice.type.labelBackgroundColor, in: RoundedRectangle(cornerRadius: 4))
                                }
                                
                                Spacer()
                                
                                Text(notice.date)
                                    .font(.m5r)
                                    .foregroundColor(.gray5)
                            }
                            
                            Text(notice.title)
                                .font(.t2)
                                .foregroundColor(.gray9)
                        }
                        
                        Divider()
                        
                        // 내용
                        Text(notice.content)
                            .font(.m4r)
                            .foregroundColor(.gray9)
                            .lineSpacing(4)
                        
                        // 이미지들 (있는 경우)
                        if !notice.imageUrls.isEmpty {
                            LazyVStack(spacing: 12) {
                                ForEach(notice.imageUrls, id: \.self) { imageUrl in
                                    AsyncImage(url: URL(string: imageUrl)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray2)
                                            .frame(height: 200)
                                            .overlay(
                                                ProgressView()
                                            )
                                    }
                                    .frame(maxHeight: 300)
                                    .cornerRadius(8)
                                }
                            }
                        }
                        
                        Divider()
                        
                        // 조회수, 공감수
                        HStack {
                            HStack(spacing: 4) {
                                Image("eye")
                                Text("조회 \(notice.views)")
                                    .font(.m5r)
                                    .foregroundColor(.gray5)
                            }
                            
                            HStack(spacing: 4) {
                                Image("heart")
                                Text("공감 \(notice.likes)")
                                    .font(.m5r)
                                    .foregroundColor(.gray5)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray4)
                    
                    Text("공지사항을 찾을 수 없습니다.")
                        .font(.m4r)
                        .foregroundColor(.gray5)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            await loadNoticeDetail()
        }
    }
    
    private func loadNoticeDetail() async {
        isLoading = true
        
        guard let id = Int(noticeId) else {
            ToastManager.shared.show(.errorWithMessage("잘못된 공지사항 ID입니다."))
            isLoading = false
            return
        }
        
        do {
            let response = try await noticeBoardRepository.getNoticeBoardDetail(id: id)
            notice = Notice(from: response.result)
        } catch {
            print("Notice detail loading error: \(error)")
            ToastManager.shared.show(.errorWithMessage("공지사항을 불러오는 중 오류가 발생했습니다."))
        }
        
        isLoading = false
    }
}

#Preview {
    NoticeDetailView(noticeId: "Asdf")
}
