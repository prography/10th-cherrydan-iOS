import KakaoSDKAuth
import KakaoSDKCommon
import NaverThirdPartyLogin
import GoogleSignIn

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    private let userRepository = UserRepository()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: "200f937cbd09c57dfbfccc2994058585")
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        // 네이버 로그인 설정
        instance?.isNaverAppOauthEnable = false
        instance?.isInAppOauthEnable = true
        instance?.setOnlyPortraitSupportInIphone(true)
        
        // 로그인 설정
        instance?.serviceUrlScheme = "com.teamSquid.cherrydan"
        instance?.consumerKey = "KtLI1nHlzBXL5AJqqfft"
        instance?.consumerSecret = "dFgYGZ7GuG"  // 애플리케이션에서 사용하는 클라이언트 시크릿
        instance?.appName = "Cherrdan"  // 애플리케이션 이름
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        setupPushNotifications(application)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let naverHandled = NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options), naverHandled {
            return true
        }
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        return false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Task {
            await FCMManager.shared.updateTokenWithPermission()
        }
    }
    
    /// - Note: 외부에서 Apple Push Notification 권한 수락을 하였을 때 호출되는 이벤트입니다. 서버로 최신 활성화 fcmToken을 갱신합니다.
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        
        Task {
            await FCMManager.shared.updateTokenWithPermission()
        }
    }
}

// MARK: - Private Methods
private extension AppDelegate {
    func setupPushNotifications(_ application: UIApplication) {
        notificationCenter.delegate = self
        
        Task {
            do {
                // 권한과 무관하게 APNs 등록을 항상 수행하여 FCM 토큰 발급 안정화
                await MainActor.run {
                    application.registerForRemoteNotifications()
                }
                
                let token = await Messaging.fetchFCMToken()
                if let token {
                    KeychainManager.shared.saveFcmToken(token)
                }
                
                let granted = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
                if granted {
                    print("🔔 알림 권한이 허용되었습니다.")
                } else {
                    print("🔔 알림 권한이 거부되었습니다.")
                }
            } catch {
                print("🔔 알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    func handleNotificationData(_ userInfo: [AnyHashable: Any], isAppActive: Bool = true) {
        guard let messageType = userInfo["type"] as? String else { return }
        
        // 서버 타입 → 앱 탭 매핑
        let targetTab: NotificationType?
        switch messageType {
        case "keyword_campaign":
            targetTab = .custom
        case "activity_reminder":
            targetTab = .activity
        default:
            targetTab = nil
        }
        
        if let targetTab {
            NotificationCenter.default.post(
                name: .didTapPushNotification,
                object: nil,
                userInfo: [PushRouteUserInfoKey.targetTab: targetTab]
            )
            return
        }
    }
    
    func handleChatNotification(_ userInfo: [AnyHashable: Any], isAppActive: Bool) {
        // TODO: 채팅 알림 처리 로직 구현
        print("💬 채팅 알림 수신")
    }
    
    func handleReminderNotification(_ userInfo: [AnyHashable: Any], isAppActive: Bool) {
        // TODO: 리마인더 알림 처리 로직 구현
        print("⏰ 리마인더 알림 수신")
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        handleNotificationData(userInfo)
        
        return [.banner, .badge, .sound]
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        
        handleNotificationData(userInfo, isAppActive: false)
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Task {
            await FCMManager.shared.updateTokenWithPermission()
        }
    }
}
