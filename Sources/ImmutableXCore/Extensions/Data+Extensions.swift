import Foundation

extension Data {
    init(hex: String) {
        self.init([UInt8](hex: hex))
    }

    func asHexString() -> String {
        lazy.reduce(into: "") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            $0 += s
        }
    }
}
