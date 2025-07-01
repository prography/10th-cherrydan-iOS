import SwiftUI

struct NoticeBoardView: View {
    @StateObject private var viewModel = NoticeBoardViewModel()
    
    var body: some View {
        CHScreen(horizontalPadding: 0) {
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
                            }
                        
                        Divider().background(Color.gray2)
                    }
                }
            }
        }
    }
    
    private var header: some View {
        CDHeaderWithLeftContent() {
            HStack(spacing: 16) {
                Button(action: {
                    //
                }) {
                    Text("체리단 소식")
                        .font(.t1)
                        .foregroundStyle(.gray9)
                }
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
