import BigInt
import Foundation

/// Elliptic Curve generated private key
public struct PrivateKey: Equatable, Codable {
    public let number: BigInt

    public var asData: Data {
        number.as256bitLongData()
    }

    /// - Throws: ``ImmutableXError/invalidKeyData`` if given `number` is not within curve range
    public init(number: BigInt) throws {
        // Private Key must be in the curve range
        guard case 1 ..< StarkCurve.N = number else { throw ImmutableXError.invalidKeyData }
        self.number = number
    }

    /// - Throws: ``ImmutableXError/invalidKeyData`` if given `hex` is not valid or within curve range
    public init(hex: String) throws {
        guard let number = BigInt(hexString: hex) else {
            throw ImmutableXError.invalidKeyData
        }
        try self.init(number: number)
    }
}
