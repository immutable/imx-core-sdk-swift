import Foundation

public extension String {
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
}
