import BigInt
import Foundation

/// A representation of an Affine Elliptic Curve Point
public struct CurvePoint: Equatable, Codable {
    public let x: BigInt
    public let y: BigInt

    public init(x: BigInt, y: BigInt) {
        self.x = x
        self.y = y
    }
}
