import Foundation

extension Date {
    func daysAgoString(from reference: Date = Date()) -> String {
        let calendar = Calendar.current
        let startOfSelf = calendar.startOfDay(for: self)
        let startOfReference = calendar.startOfDay(for: reference)
        let components = calendar.dateComponents([.day], from: startOfSelf, to: startOfReference)
        guard let days = components.day else { return "" }
        if days == 0 {
            return "오늘 발표"
        } else if days > 0 {
            return "발표 \(days)일 지남"
        } else {
            return "발표 \(-days)일 남음"
        }
    }
} 