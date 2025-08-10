import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var router: HomeRouter
    @StateObject var viewModel: NotificationViewModel = NotificationViewModel()
    @State private var isDeleteMode: Bool = false
    
    // 현재 탭의 항목이 모두 선택되었는지 여부
    private var isAllSelected: Bool {
        let ids = currentIds
        guard !ids.isEmpty else { return false }
        return Set(ids).isSubset(of: viewModel.selectedNotifications)
    }
    
    private var currentIds: [Int] {
        if viewModel.selectedTab == .activity {
            return viewModel.activityNotifications.map { $0.id }
        } else {
            return viewModel.keywordNotifications.map { $0.id }
        }
    }
    
    private func toggleSelectAll() {
        let ids = currentIds
        guard !ids.isEmpty else { return }
        
        if isAllSelected {
            viewModel.deselectAll(ids)
        } else {
            viewModel.selectAll(ids)
        }
    }
    
    var body: some View {
        CDScreen(horizontalPadding: 0, isLoading: viewModel.isLoading || viewModel.isLoadingMore) {
            CDBackHeaderWithTitle(title: "알림") {
                if !viewModel.isDeleteMode {
                    Button(action: {
                        viewModel.isDeleteMode = true
                    }){
                        Image("trash")
                    }
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
                        activityListSection
                    } else {
                        keywordListSection
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 4)
            }
            .onAppear {
                viewModel.loadNotifications()
            }
            .refreshable {
                viewModel.loadNotifications()
            }
        }
    }
    
    @ViewBuilder
    private var activityListSection: some View {
        if viewModel.activityNotifications.isEmpty && !viewModel.isLoading {
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
        } else {
            ForEach(Array(zip(viewModel.activityNotifications.indices, viewModel.activityNotifications)), id: \.1.id) { index, notification in
                NotificationRow(
                    notification: notification,
                    isSelected: viewModel.isSelected(notification.id),
                    onSelect: {
                        viewModel.toggleSelect(notification.id)
                    }
                )
                .onAppear {
                    if index == viewModel.activityNotifications.count - 10 && viewModel.hasNextPage && !viewModel.isLoadingMore {
                        viewModel.loadNextPage()
                    }
                }
                
                Divider()
            }
        }
    }
    
    @ViewBuilder
    private var keywordListSection: some View {
        if viewModel.keywordNotifications.isEmpty {
            emptyView
        } else {
            ForEach(Array(zip(viewModel.keywordNotifications.indices, viewModel.keywordNotifications)), id: \.1.id) { index, notification in
                Button(action: {
                    router.push(to: .keywordAlertDetail(keyword: notification.keyword))
                }) {
                    KeywordNotificationRow(
                        notification: notification,
                        isSelected: viewModel.isSelected(notification.id),
                        onSelect: {
                            viewModel.toggleSelect(notification.id)
                        }
                    )
                }
                .onAppear {
                    if index == viewModel.keywordNotifications.count - 10 && viewModel.hasNextPage && !viewModel.isLoadingMore {
                        viewModel.loadNextPage()
                    }
                }
                Divider()
            }
        }
    }
    
    private var loadingMoreIndicator: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(0.8)
                Spacer()
            }
            .frame(height: 60)
            .background(Color.clear)
        }
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray4)
            
            Text("키워드 알림이 없습니다")
                .font(.m4r)
                .foregroundColor(.gray5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
    
    private var tabSection: some View {
        HStack(spacing: 0) {
            ForEach(NotificationType.allCases, id: \.self) { tab in
                let isSelected = viewModel.selectedTab == tab
                Button(action: {
                    viewModel.selectTab(tab)
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
            
            Text("알림 받는 키워드 \(viewModel.keywordCount)개")
                .font(.m4r)
                .foregroundColor(.gray9)
            
            Spacer()
            
            Button(action: {
                router.push(to: .keywordSettings)
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
            Button(action: { toggleSelectAll() }) {
                HStack(spacing: 2){
                    Image("check_circle_\(isAllSelected ? "filled" : "empty")")
                    
                    Text("모두 선택")
                        .font(.m4r)
                        .foregroundColor(.gray9)
                }
            }
            
            Spacer()
            
            let hasSelectionInCurrentTab = !viewModel.selectedNotifications.intersection(Set(currentIds)).isEmpty
            if viewModel.isDeleteMode {
                HStack(spacing: 4){
                    Button(action: { viewModel.deleteSelectedAlerts() }) {
                        Text("삭제")
                            .font(.m4b)
                            .foregroundColor(hasSelectionInCurrentTab ? .mPink3 : .gray5)
                    }
                    .disabled(!hasSelectionInCurrentTab)
                    
                    Rectangle()
                        .fill(.gray4)
                        .frame(width: 1, height: 12)
                    
                    Button(action: {
                        viewModel.isDeleteMode = false
                    }) {
                        Text("취소")
                            .foregroundColor(.gray9)
                            .font(.m4b)
                    }
                }
            } else {
                Button(action: { viewModel.markSelectedAlertsAsRead() }) {
                    Text("읽음")
                }
                .font(hasSelectionInCurrentTab ? .m4b : .m4r)
                .foregroundColor(hasSelectionInCurrentTab ? .mPink3 : .gray5)
                .disabled(!hasSelectionInCurrentTab)
                
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
        .environmentObject(HomeRouter())
}
