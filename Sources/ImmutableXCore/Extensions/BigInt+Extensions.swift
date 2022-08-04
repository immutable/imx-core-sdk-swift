import BigInt
import Foundation

extension BigInt {
    var isEven: Bool {
        magnitude[bitAt: 0] == false
    }

    var byteCount: Int {
        magnitude.bitWidth.byteCountFromBitCount
    }

    init?(hexString: String) {
        self.init(hexString.dropHexPrefix, radix: 16)
    }

    init(sign: BigInt.Sign = .plus, data: Data) {
        self.init(sign: sign, magnitude: BigInt.Magnitude(data))
    }

    func asString(uppercased: Bool = false, radix: Int) -> String {
        let stringRepresentation = String(self, radix: radix)
        return uppercased ? stringRepresentation.uppercased() : stringRepresentation
    }

    func asHexString(uppercased: Bool = false) -> String {
        asString(uppercased: uppercased, radix: 16)
    }

    func asHexStringLength64(uppercased: Bool = false) -> String {
        var hexString = asString(uppercased: uppercased, radix: 16)
        while hexString.count < 64 {
            hexString = "0\(hexString)"
        }
        return hexString
    }

    func as256bitLongData() -> Data {
        asHexStringLength64().hexToData()
    }
}
