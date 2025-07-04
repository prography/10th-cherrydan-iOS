import SwiftUI

struct NotificationView: View {
    @StateObject var viewModel: NotificationViewModel = NotificationViewModel()
    @State private var selectedAll: Bool = false
    @State private var isDeleteMode: Bool = false
    @State private var keywordNum = 2
    
    var body: some View {
        CDScreen(horizontalPadding: 0) {
            CDBackHeaderWithTitle(title:"알림"){
                Button(action: {
                    isDeleteMode.toggle()
                }) {
                    Image("trash")
                }
            }
            .padding(.horizontal, 16)
            
            tabSection
                .padding(.horizontal, 16)
            
            Divider()
                .padding(.bottom, 20)
            
            if viewModel.selectedTab == .custom {
                keywordSection
                    .padding(.horizontal, 16)
            }
            
            selectSection
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    if viewModel.selectedTab == .activity {
                        if viewModel.isLoading {
                            loadingView
                        } else if viewModel.activityNotifications.isEmpty {
                            emptyView
                        } else {
                            ForEach(viewModel.activityNotifications) { notification in
                                NotificationRow(
                                    notification: notification,
                                    isSelected: selectedAll,
                                    onSelect: {
                                        
                                    }
                                )
                                Divider().background(Color.gray2)
                            }
                            
                            if viewModel.hasNextPage && !viewModel.isLoading {
                                loadMoreButton
                            }
                        }
                    } else {
                        if viewModel.isLoading {
                            loadingView
                        } else if viewModel.activityNotifications.isEmpty {
                            emptyView
                        } else {
//                            ForEach(viewModel.keywordNotifications) { notification in
//                                NotificationRow(
//                                    notification: notification,
//                                    isSelected: selectedAll,
//                                    onSelect: {
//                                        
//                                    }
//                                )
//                                Divider().background(Color.gray2)
//                            }
                            
                            if viewModel.hasNextPage && !viewModel.isLoading {
                                loadMoreButton
                            }
                        }
                        
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 4)
            }
            .refreshable {
                await viewModel.refreshNotifications()
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            Text("알림을 불러오는 중...")
                .font(.m4r)
                .foregroundColor(.gray5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.gray4)
            
            Text(message)
                .font(.m4r)
                .foregroundColor(.gray5)
                .multilineTextAlignment(.center)
            
            Button("다시 시도") {
                Task {
                    await viewModel.refreshNotifications()
                }
            }
            .font(.m4b)
            .foregroundColor(.mPink3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray4)
            
            Text("새로운 알림이 없습니다")
                .font(.m4r)
                .foregroundColor(.gray5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private var loadMoreButton: some View {
        Button("더 보기") {
            Task {
                await viewModel.loadMoreNotifications()
            }
        }
        .font(.m4r)
        .foregroundColor(.mPink3)
        .padding(.vertical, 16)
    }
    
    private var tabSection: some View {
        HStack(spacing: 0) {
            ForEach(NotificationType.allCases, id: \.self) { tab in
                let isSelected = viewModel.selectedTab == tab
                Button(action: {
                    viewModel.selectedTab = tab
                }) {
                    VStack(spacing: 8){
                        Text(tab.title)
                            .font(isSelected ? .m3b : .m3r)
                            .foregroundColor(isSelected ? .mPink3 : .gray4)
                        
                        Rectangle()
                            .fill(isSelected ? .mPink3 : .clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    @ViewBuilder
    private var keywordSection: some View {
        HStack(spacing: 4) {
            Image("notification")
                .resizable()
                .frame(width: 20, height: 20)
            
            Text("알림 받는 키워드 \(keywordNum)개")
                .font(.m4r)
                .foregroundColor(.gray9)
            
            Spacer()
            
            Button(action: {
                
            }) {
                HStack(spacing: 4) {
                    Image("edit")
                    Text("키워드 설정")
                        .font(.m5r)
                        .foregroundColor(.gray5)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(.gray2, in: RoundedRectangle(cornerRadius: 24))
            }
        }
    }
    
    private var selectSection: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(action: { selectedAll.toggle() }) {
                HStack(spacing: 2){
                    Image("check_circle_\(selectedAll ? "filled" : "empty")")
                    
                    Text("모두 선택")
                        .font(.m4r)
                        .foregroundColor(.gray9)
                }
            }
            
            Spacer()
            
            if viewModel.selectedTab == .activity {
                Button(action: {
                    // 모든 알림을 읽음 처리
                }) {
                    Text("읽음")
                        .font(.m4r)
                        .foregroundColor(.gray5)
                }
            } else {
                HStack(spacing: 4){
                    Button(action: {}) {
                        Text("삭재")
                            .foregroundColor(.mPink3)
                    }
                    
                    Rectangle()
                        .fill(.gray4)
                        .frame(width: 1, height: 12)
                    
                    Button(action: {}) {
                        Text("취소")
                            .foregroundColor(.gray9)
                    }
                }
                .font(.m4b)
            }
        }
        .frame(height: 32)
    }
}

// MARK: - Dummy Data for Custom Notifications
private var customNotifications: [ActivityNotification] {
    return []
}

#Preview {
    NotificationView()
}
