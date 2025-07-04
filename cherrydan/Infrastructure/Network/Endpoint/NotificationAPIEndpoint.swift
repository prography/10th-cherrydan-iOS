import Foundation

enum NotificationAPIEndpoint {
    case notificationsUser(userId: String)
    case notificationsUserTest(userId: String)
    case notificationsUserSimple(userId: String)
    case notificationsMultiple
    case notificationsTopic(topic: String)
    case notificationsToken(token: String)
    case notificationsBroadcast
    
    // Activity Notifications
    case activityNotifications
    case markAsRead(notificationId: Int)
    
    var path: String {
        switch self {
        case .notificationsUser(let userId): return "/notifications/users/\(userId)"
        case .notificationsUserTest(let userId): return "/notifications/users/\(userId)/test"
        case .notificationsUserSimple(let userId): return "/notifications/users/\(userId)/simple"
        case .notificationsMultiple: return "/notifications/users/multiple"
        case .notificationsTopic(let topic): return "/notifications/topics/\(topic)"
        case .notificationsToken(let token): return "/notifications/tokens/\(token)"
        case .notificationsBroadcast: return "/notifications/broadcast"
        case .activityNotifications: return "/notifications/activity"
        case .markAsRead(let notificationId): return "/notifications/\(notificationId)/read"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .notificationsUser: return .post
        case .notificationsUserTest: return .post
        case .notificationsUserSimple: return .post
        case .notificationsMultiple: return .post
        case .notificationsTopic: return .post
        case .notificationsToken: return .post
        case .notificationsBroadcast: return .post
        case .activityNotifications: return .get
        case .markAsRead: return .put
        }
    }
} 
