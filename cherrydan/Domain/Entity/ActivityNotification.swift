struct ActivityNotification: Identifiable, Equatable, Codable {
    let id: Int
    let campaignId: Int
    let campaignTitle: String
    let applyEndDate: String
    let alertDate: String
    let isRead: Bool
    let dday: Int
}

// MARK: - Dummy Factory (DEBUG only)
#if DEBUG
extension ActivityNotification {
    static func dummy(count: Int = 10) -> [ActivityNotification] {
        (1...max(count, 0)).map { index in
            ActivityNotification(
                id: index,
                campaignId: 1000 + index,
                campaignTitle: "더미 캠페인 \(index)",
                applyEndDate: "2025-08-31",
                alertDate: "2025-08-10T12:00:00",
                isRead: index % 2 == 0,
                dday: Int.random(in: 0...10)
            )
        }
    }
}
#endif
