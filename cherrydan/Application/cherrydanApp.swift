import SwiftUI

@main
struct cherrydanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            CherrydanView()
        }
    }
}
