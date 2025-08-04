import Foundation
import SwiftUI

enum NoticeFilter: CaseIterable {
    case popular, latest, oldest
    var title: String {
        switch self {
        case .popular: return "인기순"
        case .latest: return "최신순"
        case .oldest: return "오래된 순"
        }
    }
}

@MainActor
class NoticeBoardViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var selectedFilter: NoticeFilter = .popular
    @Published var isLoading: Bool = true
    @Published var errorMessage: String? = nil
    
    private let noticeBoardRepository: NoticeBoardRepository
    
    var filteredNotices: [Notice] {
        switch selectedFilter {
        case .popular:
            return notices.sorted { $0.likes > $1.likes }
        case .latest:
            return notices.sorted { $0.date > $1.date }
        case .oldest:
            return notices.sorted { $0.date < $1.date }
        }
    }
    
    init(noticeBoardRepository: NoticeBoardRepository = NoticeBoardRepository()) {
        self.noticeBoardRepository = noticeBoardRepository
        Task {
            await loadNoticeBoard()
        }
    }
    
    func loadNoticeBoard() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await noticeBoardRepository.getNoticeBoard()
            notices = response.result.content.map { Notice(from: $0) }
        } catch {
            print("Notice board loading error: \(error)")
            errorMessage = "공지사항을 불러오는 중 오류가 발생했습니다."
            // API 실패 시 더미 데이터 로드
            loadDummyData()
        }
        
        isLoading = false
    }
    
    func refreshNoticeBoard() async {
        await loadNoticeBoard()
    }
    
    private func loadDummyData() {
        notices = [
            Notice(type: .tip, title: "블로그 지수 확인 방법", content: "오늘은 키워드 고르는 법을 준비했습니다. 다들 키워드 선택할 때 고민 많이 하셨죠? 체리단이 준비한 꿀팁으로 내 게시글의 조회수를 up up...", date: "2025.05.17", views: 11170, likes: 14),
            Notice(type: .notice, title: "패널티 시스템 안내", content: "오늘은 키워드 고르는 법을 준비했습니다. 다들 키워드 선택할 때 고민 많이 하셨죠? 체리단이 준비한 꿀팁으로 내 게시글의 조회수를 up up...", date: "2025.05.17", views: 11170, likes: 14),
            Notice(type: .event, title: "1만 다운로드 기념 이벤트🎉", content: "오늘은 키워드 고르는 법에 대해 이야기해볼게요! 체리단이 알려주는 꿀팁으로, 내 게시글을 더 많은 사람들에게 노출...", date: "2025.05.17", views: 11170, likes: 14),
            Notice(type: .hot, title: "체험단 선정 잘 되는 꿀팁 알려드릴게요!", content: "오늘은 키워드 고르는 법을 준비했습니다. 다들 키워드 선택할 때 고민 많이 하셨죠? 체리단이 준비한 꿀팁으로 내 게시글의 조회수를 up up...", date: "2025.05.17", views: 11170, likes: 14),
            Notice(type: .normal, title: "체험단 선정 잘 되는 꿀팁 알려드릴게요!", content: "오늘은 키워드 고르는 법을 준비했습니다. 다들 키워드 선택할 때 고민 많이 하셨죠? 체리단이 준비한 꿀팁으로 내 게시글의 조회수를 up up...", date: "2025.05.17", views: 11170, likes: 14)
        ]
    }
} 
