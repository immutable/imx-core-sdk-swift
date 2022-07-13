import BigInt
import Foundation

public struct StarkSignature: Equatable {
    public let r: BigInt
    public let s: BigInt

    public init(r: BigInt, s: BigInt) throws {
        guard r < StarkCurve.P, r > BigInt.zero, s < StarkCurve.N, s > BigInt.zero else {
            throw SignatureError.invalidArguments
        }

        self.r = r
        self.s = s
    }

    /// Returns ``r`` and ``s`` formatted and serialized as hex (including prefix)
    internal func serialized() -> String {
        (r.asHexString().padLeft(length: 64) + s.asHexString().padLeft(length: 64)).addHexPrefix
    }
}
