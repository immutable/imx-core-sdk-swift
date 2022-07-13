import BigInt
import CryptoKit
import Foundation

public struct Message {
    public let hashedData: Data

    public var asBigInt: BigInt {
        BigInt(data: hashedData)
    }

    public var hashedHex: String {
        hashedData.asHexString()
    }

    public init(hashedData: Data) {
        self.hashedData = hashedData
    }

    public init(hashedHex: String) {
        self.init(hashedData: hashedHex.hexToData())
    }
}
