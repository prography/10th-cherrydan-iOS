import Foundation
import SwiftUI

enum NoticeType: String, CaseIterable {
    case notice, event, tip, hot, normal
    
    var label: String? {
        switch self {
        case .notice: return "공지"
        case .event: return "Event"
        case .tip: return "Tip"
        case .hot: return "Hot"
        default: return nil
        }
    }
    
    var labelBackgroundColor: Color {
        switch self {
        case .notice, .event, .tip: return .gray5
        case .hot: return .mPink2
        default: return .clear
        }
    }
    var labelTextColor: Color {
        switch self {
        case .notice, .event, .tip: return .pBlue
        case .hot: return .gray0
        default: return .clear
        }
    }
}

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

class NoticeBoardViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var selectedFilter: NoticeFilter = .popular
    @Published var isLoading: Bool = true
    
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
    
    init() {
        loadDummy()
    }
    
    func loadDummy() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.notices = [
                Notice(type: .tip, title: "블로그 지수 확인 방법", content: "오늘은 키워드 고르는 법을 준비했습니다. 다들 키워드 선택할 때 고민 많이 하셨죠? 체리단이 준비한 꿀팁으로 내 게시글의 조회수를 up up...", date: "2025.05.17", views: 11170, likes: 14),
                Notice(type: .notice, title: "패널티 시스템 안내", content: "오늘은 키워드 고르는 법을 준비했습니다. 다들 키워드 선택할 때 고민 많이 하셨죠? 체리단이 준비한 꿀팁으로 내 게시글의 조회수를 up up...", date: "2025.05.17", views: 11170, likes: 14),
                Notice(type: .event, title: "1만 다운로드 기념 이벤트🎉", content: "오늘은 키워드 고르는 법에 대해 이야기해볼게요! 체리단이 알려주는 꿀팁으로, 내 게시글을 더 많은 사람들에게 노출...", date: "2025.05.17", views: 11170, likes: 14),
                Notice(type: .hot, title: "체험단 선정 잘 되는 꿀팁 알려드릴게요!", content: "오늘은 키워드 고르는 법을 준비했습니다. 다들 키워드 선택할 때 고민 많이 하셨죠? 체리단이 준비한 꿀팁으로 내 게시글의 조회수를 up up...", date: "2025.05.17", views: 11170, likes: 14),
                Notice(type: .normal, title: "체험단 선정 잘 되는 꿀팁 알려드릴게요!", content: "오늘은 키워드 고르는 법을 준비했습니다. 다들 키워드 선택할 때 고민 많이 하셨죠? 체리단이 준비한 꿀팁으로 내 게시글의 조회수를 up up...", date: "2025.05.17", views: 11170, likes: 14)
            ]
            self.isLoading = false
        }
    }
} 
