import BigInt
import Foundation

/// Elliptic Curve generated public key
public struct PublicKey: Equatable {
    public let point: CurvePoint
    public let compressedData: Data

    public var compressedHex: String {
        compressedData.asHexString()
    }

    public init(point: CurvePoint) throws {
        self.point = point
        compressedData = Data(point.y.isEven ? [0x02] : [0x03]) + point.x.as256bitLongData()
    }

    public init(privateKey: PrivateKey) throws {
        try self.init(point: StarkCurve.multiplyG(by: privateKey.number))
    }

    public static func == (lhs: PublicKey, rhs: PublicKey) -> Bool {
        lhs.point == rhs.point
    }
}
