import Foundation

struct Notice: Identifiable {
    let id: UUID = UUID()
    let type: NoticeType
    let title: String
    let content: String
    let date: String
    let views: Int
    let likes: Int
    var isHot: Bool { type == .hot }
}
