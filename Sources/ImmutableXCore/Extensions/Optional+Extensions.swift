import Foundation

extension Optional {
    /// Return wrapped value if exists or thorws given ``error`` otherwise
    func orThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw error()
        }
    }
}
