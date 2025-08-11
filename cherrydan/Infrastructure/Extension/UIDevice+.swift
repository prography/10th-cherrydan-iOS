import UIKit
import Foundation

public extension UIDevice {
    /// Returns device identifier like "iPhone17,1". Simulator uses SIMULATOR_MODEL_IDENTIFIER if available.
    var modelIdentifier: String {
        #if targetEnvironment(simulator)
        if let simId = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"], !simId.isEmpty {
            return simId
        }
        #endif
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce(into: "") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return }
            identifier.append(String(UnicodeScalar(UInt8(value))))
        }
        return identifier
    }

    /// Returns human readable marketing device name like "iPhone 16 Pro". Falls back to modelIdentifier if unknown.
    var modelName: String {
        let identifier = modelIdentifier
        // Keep this mapping minimal but current. Unknown identifiers will fall back to the raw identifier.
        let mapping: [String: String] = [
            // iPhone 16 family (approximate identifiers; fall back if they change)
            "iPhone17,1": "iPhone 16 Pro",
            "iPhone17,2": "iPhone 16 Pro Max",
            "iPhone17,3": "iPhone 16",
            "iPhone17,4": "iPhone 16 Plus",
            // iPhone 15 family
            "iPhone15,2": "iPhone 14 Pro",
            "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone14,7": "iPhone 14",
            "iPhone14,8": "iPhone 14 Plus",
            // iPhone 13 family
            "iPhone14,5": "iPhone 13",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,4": "iPhone 13 mini",
            // iPhone 12 family
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone13,1": "iPhone 12 mini",
            // iPhone 11 family
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            // iPhone X / XS / XR
            "iPhone10,3": "iPhone X",
            "iPhone10,6": "iPhone X",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max",
            "iPhone11,6": "iPhone XS Max",
            "iPhone11,8": "iPhone XR",
            // iPhone SE
            "iPhone12,8": "iPhone SE (2nd generation)",
            "iPhone14,6": "iPhone SE (3rd generation)",
        ]
        return mapping[identifier] ?? identifier
    }
}


