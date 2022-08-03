import Foundation

extension Optional {
    /// Return wrapped value if exists or thorws given ``ImmutableXCoreError`` otherwise
    func orThrow(_ error: @autoclosure () -> ImmutableXCoreError) throws -> Wrapped {
        if let wrapped = self {
            return wrapped
        } else {
            throw error()
        }
    }
}
