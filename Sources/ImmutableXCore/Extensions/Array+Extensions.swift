import Foundation

// https://github.com/krzyzanowskim/CryptoSwift/blob/main/Sources/CryptoSwift/Array%2BExtension.swift#L34
extension [UInt8] {
    @inlinable
    init(reserveCapacity: Int) {
        self = [Element]()
        self.reserveCapacity(reserveCapacity)
    }

    init(hex: String) {
        self.init(reserveCapacity: hex.unicodeScalars.lazy.underestimatedCount)
        var buffer: UInt8?
        var skip = hex.hasPrefix("0x") ? 2 : 0

        for char in hex.unicodeScalars.lazy {
            guard skip == 0 else {
                skip -= 1
                continue
            }

            guard char.value >= 48, char.value <= 102 else {
                removeAll()
                return
            }

            let v: UInt8
            let c = UInt8(char.value)

            switch c {
            case let c where c <= 57:
                v = c - 48
            case let c where c >= 65 && c <= 70:
                v = c - 55
            case let c where c >= 97:
                v = c - 87
            default:
                removeAll()
                return
            }

            if let b = buffer {
                append(b << 4 | v)
                buffer = nil
            } else {
                buffer = v
            }
        }

        if let b = buffer {
            append(b)
        }
    }

    /// Convert array of bytes to the given ``byteLength`` prepending the given ``prefix``.
    func asHexString(byteLength: Int, prefix: String = "0x") -> String {
        let diff = Swift.max(count - byteLength, 0)
        return prefix + Data(dropFirst(diff)).asHexString()
    }
}
