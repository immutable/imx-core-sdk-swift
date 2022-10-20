/// An enum for defining the environment the SDK will communicate with
public enum ImmutableXBase {
    /// Ethereum network
    case production

    /// The default test network (currently Goerli)
    case sandbox

    internal var publicApiUrl: String {
        switch self {
        case .production:
            return "https://api.x.immutable.com"
        case .sandbox:
            return "https://api.sandbox.x.immutable.com"
        }
    }

    internal var moonpayApiKey: String {
        switch self {
        case .production:
            return "pk_live_lgGxv3WyWjnWff44ch4gmolN0953"
        case .sandbox:
            return "pk_test_nGdsu1IBkjiFzmEvN8ddf4gM9GNy5Sgz"
        }
    }

    internal var buyCryptoUrl: String {
        switch self {
        case .production:
            return "https://buy.moonpay.io"
        case .sandbox:
            return "https://buy-staging.moonpay.io"
        }
    }
}
