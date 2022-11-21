import BigInt
import CryptoKit
import Foundation

struct Message {
    let hashedData: Data

    var asBigInt: BigInt {
        BigInt(data: hashedData)
    }

    init(hashedData: Data) {
        self.hashedData = hashedData
    }

    init(hashedHex: String) {
        self.init(hashedData: hashedHex.hexToData())
    }
}
