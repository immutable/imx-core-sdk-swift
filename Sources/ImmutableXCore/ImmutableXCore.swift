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

    /// Defines the level of logging for ImmutableXCore network calls. Defaults to `.none`.
    ///
    ///  Setting `logLevel` to `.calls(including: [])` will log all requests and responses with HTTP Method and URL.
    ///  For richer logging include extra details of the calls to be logged, e.g.
    ///
    ///  ```swift
    ///  logLevel = .calls(including: [
    ///     .requestHeaders, .responseBody
    ///  ])
    ///  ```
    ///
    /// - Note: Logs are only available in debug mode.
    public static var logLevel = ImmutableXHTTPLoggingLevel.none
}
