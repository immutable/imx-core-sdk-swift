import BigInt
import Foundation

/// Elliptic Curve generated public key
public struct ECPublicKey: Equatable, Codable {
    public let point: ECCurvePoint
    public let number: BigInt

    /// A representation of the public key sanitized to be Stark friendly
    public var asStarkPublicKey: String {
        Array(hex: number.asHexString().sanitizeBytes()).asHexString(byteLength: Constants.starkPrivateKeyLength)
    }

    public init(point: ECCurvePoint) throws {
        self.point = point
        number = BigInt(data: Data(point.y.isEven ? [0x02] : [0x03]) + point.x.as256bitLongData())
    }

    public init(privateKey: ECPrivateKey) throws {
        try self.init(point: StarkCurve.multiplyG(by: privateKey.number))
    }

    public static func == (lhs: ECPublicKey, rhs: ECPublicKey) -> Bool {
        lhs.point == rhs.point
    }
}
