import Foundation

public enum ImmutableXCore {
    /// Returns the version of the sdk reading from the `version` file, e.g. `"1.0.0"`
    internal static var sdkVersion: String {
        let file = Bundle.module.path(forResource: "version", ofType: "")!
        // swiftlint:disable:next force_try
        return try! String(contentsOfFile: file).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// The environment the SDK will communicate with. Defaults to `.ropsten`.
    public static var base = ImmutableXBase.ropsten
}
