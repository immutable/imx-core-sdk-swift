import Foundation

extension Int {
    var asHexString: String {
        String(format: "%02x", self)
    }

    var byteCountFromBitCount: Int {
        Int(floor(Double(self + 7) / Double(8)))
    }
}

extension UInt8 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }
}

extension UInt32 {
    var data: Data {
        var int = self
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
}
