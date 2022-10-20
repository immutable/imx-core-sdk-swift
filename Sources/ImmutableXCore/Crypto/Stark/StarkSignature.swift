import BigInt
import Foundation

public struct StarkSignature: Equatable {
    public let r: BigInt
    public let s: BigInt

    /// - Throws: ``ImmutableXError/invalidStarkSignature`` if given `r` or `s` are not within curve range
    public init(r: BigInt, s: BigInt) throws {
        guard r < StarkCurve.P, r > BigInt.zero, s < StarkCurve.N, s > BigInt.zero else {
            throw ImmutableXError.invalidStarkSignature
        }

        self.r = r
        self.s = s
    }

    /// Returns ``r`` and ``s`` formatted and serialized as hex (including prefix)
    internal func serialized() -> String {
        (r.asHexString().padLeft(length: 64) + s.asHexString().padLeft(length: 64)).addHexPrefix
    }
}
