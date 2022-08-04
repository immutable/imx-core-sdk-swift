import Foundation

extension String {
    /// Drops "0x" prefix if exists
    var dropHexPrefix: String {
        hasPrefix("0x") ? String(dropFirst(2)) : self
    }

    /// Adds "0x" prefix if doesnt exist
    var addHexPrefix: String {
        hasPrefix("0x") ? self : "0x" + self
    }

    func hexToData() -> Data {
        Data([UInt8](hex: self))
    }

    var hexaToBytes: [UInt8] {
        var start = startIndex
        return stride(from: 0, to: count, by: 2).compactMap { _ in
            let end = index(after: start)
            defer { start = index(after: end) }
            return UInt8(self[start ... end], radix: 16)
        }
    }

    var hexaToBinary: String {
        hexaToBytes.map {
            let binary = String($0, radix: 2)
            return repeatElement("0", count: 8 - binary.count) + binary
        }.joined()
    }

    /// Pads the string to the specified length at the beginning with the specified character or space.
    /// - Parameters:
    ///     - length: the desired string length.
    ///     - padding: the character to pad string with, if it has length less than the length specified. "0" is used by default.
    /// - Returns: Returns a string of length at least ``length`` consisting of this string prepended  with ``padding`` as
    /// many times as are necessary to reach that length.
    func padLeft(length: Int, padding: String = "0") -> String {
        padString(length: length, left: true, padding: padding)
    }

    /// Pads the string to the specified length at the beginning or ending with the specified character or space.
    /// - Parameters:
    ///     - length: the desired string length.
    ///     - left: defines whether the padding should be applied to the left of the string
    ///     - padding: the character to pad string with, if it has length less than the length specified. "0" is used by default.
    /// - Returns: Returns a string of length at least ``length`` consisting of this string prepended (when ``left`` is true,
    /// otherwise appended) with ``padding`` as many times as are necessary to reach that length.
    func padString(length: Int, left: Bool, padding: String = "0") -> String {
        let diff = length - count
        var result = self

        if diff > 0 {
            let pad = String(repeating: padding, count: diff)
            result = left ? pad + self : self + pad
        }

        return result
    }

    /// Sanitizes the bytes by prepending as much ``padding`` as needed to reach the desired byte length
    /// https://github.com/pedrouid/enc-utils/blob/master/src/index.ts#L264
    func sanitizeBytes(byteSize: Int = 8, padding _: String = "0") -> String {
        let remainder = count % byteSize
        let byteLength = remainder != 0 ? ((count - remainder) / byteSize) * byteSize + byteSize : count
        return padLeft(length: byteLength)
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start ..< end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}
