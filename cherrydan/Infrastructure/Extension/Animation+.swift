import SwiftUI

extension Animation {
    struct Duration {
        static let fast: Double = 0.1
        static let mediumFast: Double = 0.2
        static let medium: Double = 0.3
    }
    
    static var fastEaseInOut: Animation {
        easeInOut(duration: Duration.fast)
    }
    
    // MARK: - Spring
    static var fastSpring: Animation {
        spring(duration: Duration.fast)
    }
    
    static var mediumFastSpring: Animation {
        spring(duration: Duration.mediumFast)
    }
    
    static var mediumSpring: Animation {
        spring(duration: Duration.medium)
    }
}
