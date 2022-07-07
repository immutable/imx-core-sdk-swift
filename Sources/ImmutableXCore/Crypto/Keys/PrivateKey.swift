import BigInt
import Foundation

/// Elliptic Curve generated private key
public struct PrivateKey: Equatable {
    public let number: BigInt

    public var asData: Data {
        number.as256bitLongData()
    }

    public init(number: BigInt) throws {
        // Private Key must be in the curve range
        guard case 1 ..< StarkCurve.N = number else { throw KeyError.invalidData }
        self.number = number
    }

    public init(hex: String) throws {
        guard let number = BigInt(hexString: hex) else {
            throw KeyError.invalidData
        }
        try self.init(number: number)
    }
}
