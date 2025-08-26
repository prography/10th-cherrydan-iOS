import Foundation
import FirebaseMessaging
import UserNotifications

final class FCMManager {
    static let shared = FCMManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let userRepository = UserRepository()
    
    private init() {}
    
    func updateTokenWithPermission() async {
        guard let fcmToken = await Messaging.fetchFCMToken() else {
            print("FCM token is nil")
            return
        }
        
        let settings = await notificationCenter.notificationSettings()
        let isAllowed = settings.authorizationStatus == .authorized
        
        do {
            _ = try await userRepository.putFcmToken(fcmToken: fcmToken, isAllowed: isAllowed)
            KeychainManager.shared.saveFcmToken(fcmToken)
            print("FCM token updated: \(fcmToken), isAllowed: \(isAllowed)")
        } catch {
            print("FCM token update failed: \(error)")
        }
    }
}
