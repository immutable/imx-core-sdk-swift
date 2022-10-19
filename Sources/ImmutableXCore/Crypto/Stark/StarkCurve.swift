import BigInt
import Foundation

/// Stark-friendly elliptic curve
///
/// The Stark-friendly elliptic curve used is defined as follows:
///
/// `y² ≡ x³ + α ⋅ x + β(modp)`
///
/// where:
///
/// ```
/// α = 1
/// β = 3141592653589793238462643383279502884197169399375105820974944592307816406665
/// p = 3618502788666131213697322783095070105623107215331596699973092056135872020481
///   = 2²⁵¹ + 17 ⋅ 2¹⁹² + 1
/// ```
///
/// The Generator point used in the ECDSA scheme is:
/// ```
/// G = (874739451078007766457464989774322083649278607533249481151382481072868806602,
///     152666792071518830868575557812948353041420400780739481342941381225525861407)
/// ```
/// https://docs.starkware.co/starkex-v4/crypto/stark-curve
struct StarkCurve {
    static let P = BigInt("3618502788666131213697322783095070105623107215331596699973092056135872020481")
    static let N = BigInt("3618502788666131213697322783095070105526743751716087489154079457884512865583")

    static let a = BigInt(1)
    static let b = BigInt("3141592653589793238462643383279502884197169399375105820974944592307816406665")

    static let G = CurvePoint(
        x: BigInt("874739451078007766457464989774322083649278607533249481151382481072868806602"),
        y: BigInt("152666792071518830868575557812948353041420400780739481342941381225525861407")
    )
}

// MARK: - Division

extension StarkCurve {
    /// Return the result of ``number`` modulus ``StarkCurve.N``.
    /// The result is always a nonnegative integer that is less than the absolute value of ``number``.
    static func modN(_ number: BigInt) -> BigInt {
        number.modulus(N)
    }

    /// Return the result of ``number`` modulus ``StarkCurve.P``.
    /// The result is always a nonnegative integer that is less than the absolute value of ``number``.
    static func modP(_ number: BigInt) -> BigInt {
        number.modulus(P)
    }

    /// Return the result of ``dividend`` modulus ``StarkCurve.N`` times ``dividend`` modulus ``StarkCurve.N``.
    static func modInverseN(_ dividend: BigInt, _ divisor: BigInt) -> BigInt {
        divide(dividend, by: divisor, mod: N)
    }

    /// Return the result of ``dividend`` modulus ``StarkCurve.P`` times ``dividend`` modulus ``StarkCurve.P``.
    static func modInverseP(_ dividend: BigInt, _ divisor: BigInt) -> BigInt {
        divide(dividend, by: divisor, mod: P)
    }

    /// Return the result of ``dividend`` modulus ``mod`` times ``dividend`` modulus ``mod``.
    static func divide(_ dividend: BigInt, by divisor: BigInt, mod: BigInt) -> BigInt {
        let d1 = dividend > 0 ? dividend : dividend + mod
        let d2 = divisor > 0 ? divisor : divisor + mod
        return (d2.inverse(mod)! * d1).modulus(mod)
    }
}

// MARK: - CurvePoint

extension StarkCurve {
    /// Adds given points ``p1`` and ``p2`` if different, otherwise doubles them
    /// https://crypto.stanford.edu/pbc/notes/elliptic/explicit.html
    static func addition(_ p1: CurvePoint?, _ p2: CurvePoint?) -> CurvePoint? {
        guard let p1 else { return p2 }
        guard let p2 else { return p1 }

        if p1.x == p2.x, p1.y != p2.y {
            return nil
        }

        if p1 == p2 {
            return doublePoint(p1)
        } else {
            return addPoint(p1, to: p2)
        }
    }

    /// Multiplies the given ``point`` by ``number``
    /// https://crypto.stanford.edu/pbc/notes/elliptic/explicit.html
    static func multiply(_ point: CurvePoint, by number: BigInt) -> CurvePoint {
        var P: CurvePoint? = point
        var r: CurvePoint!

        for i in 0 ..< number.magnitude.bitWidth {
            if number.magnitude[bitAt: i] {
                r = addition(r, P)
            }
            P = addition(P, P)
        }
        return r
    }

    /// Multiplies ``StarkCurve.G`` point by given ``number``
    static func multiplyG(by number: BigInt) -> CurvePoint {
        multiply(StarkCurve.G, by: number)
    }

    /// Adds given points ``p1`` and ``p2``
    /// https://crypto.stanford.edu/pbc/notes/elliptic/explicit.html
    private static func addPoint(_ p1: CurvePoint, to p2: CurvePoint) -> CurvePoint {
        let mipResult = modInverseP(p2.y - p1.y, p2.x - p1.x)
        let x3 = modP(mipResult * mipResult - p1.x - p2.x)
        let y3 = modP(mipResult * (p1.x - x3) - p1.y)
        return CurvePoint(x: x3, y: y3)
    }

    /// Doubles the given point ``p`` based on ``StarkCurve.a``
    /// https://crypto.stanford.edu/pbc/notes/elliptic/explicit.html
    private static func doublePoint(_ p: CurvePoint) -> CurvePoint {
        let mipResult = modInverseP(3 * (p.x * p.x) + StarkCurve.a, 2 * p.y)
        let x3 = modP(mipResult * mipResult - 2 * p.x)
        let y3 = modP(mipResult * (p.x - x3) - p.y)
        return CurvePoint(x: x3, y: y3)
    }
}
