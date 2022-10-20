/// Defines the level of logging for ImmutableX network calls.
///
/// - Note: Logs are only available in debug mode.
public enum ImmutableXHTTPLoggingLevel {
    /// Defines the granularity of the logs associated to the requests and responses
    public enum Detail {
        case requestHeaders
        case responseHeaders
        case requestBody
        case responseBody
    }

    /// No logs are displayed
    case none

    /// All requests and responses are logged with HTTP Method and URL.
    /// For richer logging include extra details of the calls to be logged.
    case calls(including: [Detail])
}
