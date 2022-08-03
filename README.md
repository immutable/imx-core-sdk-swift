<div align="center">
  <p align="center">
    <a  href="https://docs.x.immutable.com/docs">
      <img src="https://cdn.dribbble.com/users/1299339/screenshots/7133657/media/837237d447d36581ebd59ec36d30daea.gif" width="280"/>
    </a>
  </p>
</div>

---

# Immutable X Core SDK

[![Maintainability](https://api.codeclimate.com/v1/badges/a7887f9758562e49b171/maintainability)](https://codeclimate.com/repos/62be55bacb1f54014d00579d/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/a7887f9758562e49b171/test_coverage)](https://codeclimate.com/repos/62be55bacb1f54014d00579d/test_coverage)

The Immutable X Core SDK Swift provides convenient access to the Immutable API's for applications written on the Immutable X platform.

## Documentation

See the [developer guides](https://docs.x.immutable.com) for information on building on Immutable X.

See the [API reference documentation](https://docs.x.immutable.com/reference) for more information on our API's.

## Installation

### Prerequisites

- iOS 13.0 or macOS 10.15
- Swift 5.5

### Swift Package Manager

In your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/immutable/imx-core-sdk-swift.git", from: "0.1.0")
]
```

### Cocoapods

In your `Podfile`:

```ruby
platform :ios, '13.0'
use_frameworks!

target 'MyApp' do
  pod 'ImmutableXCore'
end
```

## Usage

### Initialisation

The Core SDK must be initialised before any of its classes are used. Upon initialisation the base environment and log level may be defined. Once initialised a shared instace will be available for accessing the [Workflow Functions](#workflow-functions).

For example, you initialise the SDK and retrieve a URL to buy crypto through Moonpay:

```swift
ImmutableXCore.initialize(base: .ropsten)

let url = try await ImmutableXCore.shared.buyCryptoURL(signer: signer)
```

### Workflow Functions

Utility functions accessed via `ImmutableXCore.shared` that will chain necessary API calls to complete a process or perform a transaction.

- Register a user with Immutable X
- Buy cryptocurrency via Moonpay
- Buy ERC721
- Sell ERC721
- Cancel order
- Transfer ERC20/ERC721/ETH

### Standard API Requests

The Core SDK includes classes that interact with the Immutable X APIs.

e.g. Get a list of collections ordered by name in ascending order

```swift
let collections = try await CollectionsAPI.listCollections(
    pageSize: 20,
    orderBy: "name",
    direction: "asc"
)
```

View the [OpenAPI spec](openapi.json) for a full list of API requests available in the Core SDK.

NOTE: Closure based APIs are also available.

### Wallet Connection

In order to use any workflow functions, you will need to pass in the connected wallet provider. This means you will need to implement your own Wallet L1 [Signer](https://github.com/immutable/imx-core-sdk-swift/blob/main/Sources/ImmutableXCore/Signer.swift) and L2 [StarkSigner](https://github.com/immutable/imx-core-sdk-swift/blob/main/Sources/ImmutableXCore/Signer.swift).

Once you have a `Signer` instance you can generate the user's Stark key pair and use the result to implement a `StarkSigner`.

```swift
let keyPair = try await StarkKey.generateKeyPair(from: signer)
let starkSigner = StandardStarkSigner(pair: keyPair)
```

## Autogenerated Code

Parts of the Core SDK are automagically generated.

### API Autogenerated Code

We use OpenAPI (formally known as Swagger) to auto-generate the API clients that connect to the public APIs.

The OpenAPI spec is retrieved from https://api.x.immutable.com/openapi and also saved in the repo [here](openapi.json).

Upon updating the `openapi.json` file, ensure [openapi-generator](https://openapi-generator.tech/) is installed, then run `./generateapi.sh` to regenerate the files. Any custom templates should be appropriately modified or removed as needed. These can be found in the `.openapi-generator/templates` directory.

## Changelog Management

The following headings should be used as appropriate

- Added
- Changed
- Deprecated
- Removed
- Fixed

What follows is an example with all the change headings, for real world use only use headings when appropriate.

This goes at the top of the `CHANGELOG.md` above the most recent release:

```markdown
...

## [Unreleased]

### Added

for new features.

### Changed

for changes in existing functionality.

### Deprecated

for soon-to-be removed features.

### Removed

for now removed features.

### Fixed

for any bug fixes.

...
```

The `Sources/version` file will hold the value of the previous release

```yaml
0.1.0
```

## Contributing

If you would like to contribute by reporting bugs, suggest enchacements or pull requests, please read our [contributing guide](https://github.com/immutable/imx-core-sdk-swift/blob/main/CONTRIBUTING.md).

## Getting Help

Immutable X is open to all to build on, with no approvals required. If you want to talk to us to learn more, or apply for developer grants, click below:

[Contact us](https://www.immutable.com/contact)

### Project Support

To get help from other developers, discuss ideas, and stay up-to-date on what's happening, become a part of our community on Discord.

[Join us on Discord](https://discord.gg/TkVumkJ9D6)

You can also join the conversation, connect with other projects, and ask questions in our Immutable X Discourse forum.

[Visit the forum](https://forum.immutable.com/)

#### Still need help?

You can also apply for marketing support for your project. Or, if you need help with an issue related to what you're building with Immutable X, click below to submit an issue. Select _I have a question_ or _issue related to building on Immutable X_ as your issue type.

[Contact support](https://support.immutable.com/hc/en-us/requests/new)

## License

Immutable X Core SDK Swift repository is distributed under the terms of the [Apache License (Version 2.0)](LICENSE).
