import SwiftUI

struct NoticeBoardView: View {
    @EnvironmentObject private var router: NoticeBoardRouter
    @StateObject private var viewModel = NoticeBoardViewModel()
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            header
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            
            filterSection
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredNotices) { notice in
                        NoticeBoardRow(notice: notice)
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                router.push(to: .noticeDetail(noticeId: String(notice.id)))
                            }
                        
                        Divider().background(Color.gray2)
                    }
                }
            }
            .refreshable {
                await viewModel.refreshNoticeBoard()
            }
        }
    }
    
    private var header: some View {
        CDHeaderWithLeftContent(
            onNotificationClick: {
                router.push(to: .notification)
            }, onSearchClick: {
                router.push(to: .search)
            }) {
                HStack(spacing: 16) {
                    Text("체리단 소식")
                        .font(.t1)
                        .foregroundStyle(.gray9)
                }
            }
    }
    
    private var filterSection: some View {
        HStack(spacing: 4) {
            ForEach(NoticeFilter.allCases, id: \.self) { filter in
                Button(action: { viewModel.selectedFilter = filter }) {
                    Text(filter.title)
                        .font(.m5r)
                        .foregroundColor(viewModel.selectedFilter == filter ? .gray9 : .gray5)
                        .padding(.top, 6)
                        .padding(.bottom, 8)
                        .padding(.horizontal, 12)
                    
                        .background(viewModel.selectedFilter == filter ? .pBlue : .gray2, in:RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}



#Preview {
    NoticeBoardView()
}
