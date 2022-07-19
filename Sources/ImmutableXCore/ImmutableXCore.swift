import Foundation

public struct ImmutableXCore {
    /// A shared instance of ``ImmutableXCore`` that holds configuration for ``base``, ``logLevel`` and
    /// a set o utility methods for the most common workflows for the core SDK.
    ///
    /// - Note: ``initialize(base:logLevel:)`` must be called before this instance
    /// is accessed.
    public private(set) static var shared: ImmutableXCore!

    /// The environment the SDK will communicate with. Defaults to `.ropsten`.
    public let base: ImmutableXBase

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
    public var logLevel: ImmutableXHTTPLoggingLevel

    /// Returns the version of the sdk reading from the `version` file, e.g. `"1.0.0"`
    internal var sdkVersion: String {
        let file = Bundle.module.path(forResource: "version", ofType: "")!
        // swiftlint:disable:next force_try
        return try! String(contentsOfFile: file).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// Initializes the SDK with the given ``base`` and ``logLevel`` by assigning a shared instance accessible via `ImmutableXCore.shared`.
    public static func initialize(base: ImmutableXBase = .ropsten, logLevel: ImmutableXHTTPLoggingLevel = .none) {
        ImmutableXCore.shared = ImmutableXCore(base: base, logLevel: logLevel)
    }
}
