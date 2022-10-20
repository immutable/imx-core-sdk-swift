import Foundation

extension Optional {
    /// Return wrapped value if exists or thorws given ``ImmutableXError`` otherwise
    func orThrow(_ error: @autoclosure () -> ImmutableXError) throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw error()
        }
    }
}
