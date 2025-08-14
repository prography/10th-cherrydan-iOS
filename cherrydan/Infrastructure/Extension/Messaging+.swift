import Foundation
import FirebaseMessaging

extension Messaging {
    /// FCM 토큰을 즉시 획득하기 위한 유틸리티.
    /// - Parameters:
    ///   - retries: 실패 시 재시도 횟수
    ///   - delayMillis: 재시도 간격(ms)
    /// - Returns: 유효한 FCM 토큰 또는 nil
    static func fetchFCMToken(retries: Int = 2, delayMillis: UInt64 = 300) async -> String? {
        var attempt = 0
        while attempt <= retries {
            let token: String? = await withCheckedContinuation { continuation in
                Messaging.messaging().token { token, _ in
                    continuation.resume(returning: token)
                }
            }
            if let token, token.isEmpty == false {
                return token
            }
            attempt += 1
            if attempt <= retries {
                // 0.3초 대기 후 재시도
                try? await Task.sleep(nanoseconds: delayMillis * 1_000_000)
            }
        }
        return nil
    }
}


