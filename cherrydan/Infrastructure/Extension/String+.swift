import Foundation

extension String {
    func ranges(of searchString: String, options: String.CompareOptions = []) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex {
            if let range = self.range(of: searchString, options: options, range: searchStartIndex..<self.endIndex) {
                ranges.append(range)
                searchStartIndex = range.upperBound
            } else {
                break
            }
        }
        
        return ranges
    }
    
    /// 버전 문자열을 의미적 버전 비교 (Semantic Version Comparison)
    /// "v1.0.0" 형태의 문자열을 비교할 수 있습니다.
    /// - Parameter other: 비교할 다른 버전 문자열
    /// - Returns: 현재 버전이 다른 버전보다 낮으면 true, 같거나 높으면 false
    func isVersionLower(than other: String) -> Bool {
        let currentVersion = self.cleanVersionString()
        let otherVersion = other.cleanVersionString()
        
        return currentVersion.compareSemanticVersion(to: otherVersion) == .orderedAscending
    }
    
    /// 버전 문자열을 의미적 버전 비교 (Semantic Version Comparison)
    /// "v1.0.0" 형태의 문자열을 비교할 수 있습니다.
    /// - Parameter other: 비교할 다른 버전 문자열
    /// - Returns: 현재 버전이 다른 버전보다 높으면 true, 같거나 낮으면 false
    func isVersionHigher(than other: String) -> Bool {
        let currentVersion = self.cleanVersionString()
        let otherVersion = other.cleanVersionString()
        
        return currentVersion.compareSemanticVersion(to: otherVersion) == .orderedDescending
    }
    
    /// 버전 문자열이 같은지 비교
    /// - Parameter other: 비교할 다른 버전 문자열
    /// - Returns: 버전이 같으면 true, 다르면 false
    func isVersionEqual(to other: String) -> Bool {
        let currentVersion = self.cleanVersionString()
        let otherVersion = other.cleanVersionString()
        
        return currentVersion.compareSemanticVersion(to: otherVersion) == .orderedSame
    }
    
    /// "v" 접두사를 제거하고 순수한 버전 문자열을 반환
    private func cleanVersionString() -> String {
        if self.hasPrefix("v") || self.hasPrefix("V") {
            return String(self.dropFirst())
        }
        return self
    }
    
    /// 의미적 버전 비교를 수행
    /// - Parameter other: 비교할 다른 버전 문자열 (이미 정리된 상태)
    /// - Returns: ComparisonResult
    private func compareSemanticVersion(to other: String) -> ComparisonResult {
        let currentComponents = self.split(separator: ".").compactMap { Int($0) }
        let otherComponents = other.split(separator: ".").compactMap { Int($0) }
        
        // 버전 구성 요소의 개수를 맞추기 위해 부족한 부분은 0으로 채움
        let maxCount = max(currentComponents.count, otherComponents.count)
        let paddedCurrent = currentComponents + Array(repeating: 0, count: maxCount - currentComponents.count)
        let paddedOther = otherComponents + Array(repeating: 0, count: maxCount - otherComponents.count)
        
        // 각 구성 요소를 순차적으로 비교
        for i in 0..<maxCount {
            if paddedCurrent[i] < paddedOther[i] {
                return .orderedAscending
            } else if paddedCurrent[i] > paddedOther[i] {
                return .orderedDescending
            }
        }
        
        return .orderedSame
    }
}
