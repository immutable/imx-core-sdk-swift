import BigInt
import Foundation

/// Elliptic Curve generated public key
public struct PublicKey: Equatable, Codable {
    public let point: CurvePoint
    public let number: BigInt

    /// A representation of the public key sanitized to be Stark friendly
    public var asStarkPublicKey: String {
        Array(hex: number.asHexString().sanitizeBytes()).asHexString(byteLength: Constants.starkPrivateKeyLength)
    }

    public init(point: CurvePoint) throws {
        self.point = point
        number = BigInt(data: Data(point.y.isEven ? [0x02] : [0x03]) + point.x.as256bitLongData())
    }

    public init(privateKey: PrivateKey) throws {
        try self.init(point: StarkCurve.multiplyG(by: privateKey.number))
    }

    public static func == (lhs: PublicKey, rhs: PublicKey) -> Bool {
        lhs.point == rhs.point
    }
}
