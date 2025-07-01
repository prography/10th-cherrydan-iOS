import Foundation
import SwiftUI

class NotificationViewModel: ObservableObject {
    @Published var notification: [ActivityNotification] = []
    @Published var isLoading: Bool = true
    
    init(
        notificationAPI: Notification
    ) {
        loadData()
    }
    
    func loadData() {
        isLoading = true
        notification = []
    }
}
