import Foundation

extension Encodable {
    var dictionaryFormat: [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            return dictionary ?? [:]
        } catch {
            return [:]
        }
    }
}
