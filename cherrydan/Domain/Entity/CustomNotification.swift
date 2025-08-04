//
//
//struct CustomNotification: Identifiable {
//    let id = UUID()
//    let selected: Bool
//    let isNew: Bool
//    let keyword: String?
//    let count: Int
//    let title: String
//    let content: String
//    let date: String?
//    let showChevron: Bool
//    
//    static func dummy(type: NotificationTab) -> [NotificationItem] {
//        switch type {
//        case .activity:
//            return [
//                NotificationItem(selected: false, isNew: true, keyword: nil, count: 0, title: "방문알림", content: "D-3 [양주] 리치마트 양주점_피드&힐스 방문일이 3일 남았습니다.", date: "2025.05.05", showChevron: false),
//                NotificationItem(selected: false, isNew: false, keyword: nil, count: 0, title: "방문알림", content: "D-3 [양주] 리치마트 양주점_피드&힐스 방문일이 3일 남았습니다.", date: "2025.05.05", showChevron: false),
//                NotificationItem(selected: false, isNew: true, keyword: nil, count: 0, title: "방문알림", content: "D-3 [양주] 리치마트 양주점_피드&힐스 방문일이 3일 남았습니다.", date: "2025.05.05", showChevron: false),
//                NotificationItem(selected: false, isNew: false, keyword: nil, count: 0, title: "방문알림", content: "D-3 [양주] 리치마트 양주점_피드&힐스 방문일이 3일 남았습니다.", date: "2025.05.05", showChevron: false)
//            ]
//        case .custom:
//            return [
//                NotificationItem(selected: false, isNew: true, keyword: "서초", count: 17, title: "", content: "", date: nil, showChevron: true),
//                NotificationItem(selected: false, isNew: true, keyword: "딸기케이크", count: 23, title: "", content: "", date: nil, showChevron: true)
//            ]
//        }
//    }
//}
