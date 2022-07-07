import Foundation

public extension Int {
    var byteCountFromBitCount: Int {
        Int(floor(Double(self + 7) / Double(8)))
    }
}
