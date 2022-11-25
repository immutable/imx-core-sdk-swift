# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- expose all APIs, `assetsAPI`, `balancesAPI`, `collectionsAPI`, `depositsAPI`, `encodingAPI`, `metadataAPI`, `mintsAPI`, `ordersAPI`, `projectsAPI`, `tokensAPI`, `tradesAPI`, `transfersAPI`, `usersAPI` and `withdrawalAPI` as part of ImmutableX instance.
- `getUser(ethAddress:)` has been added to ImmutableX instance.
- `getDeposit(id:)` has been added to ImmutableX instance.
- `listDeposits(pageSize:cursor:orderBy:direction:user:status:updatedMinTimestamp:updatedMaxTimestamp:tokenType:tokenId:assetId:tokenAddress:tokenName:minQuantity:maxQuantity:metadata:)` has been added to ImmutableX instance.
- `getUser(ethAddress:)` has been added to ImmutableX instance.
- `getAsset(tokenAddress:tokenId:includeFees:)` has been added to ImmutableX instance.
- `listAssets(pageSize:cursor:orderBy:direction:user:status:name:metadata:sellOrders:buyOrders:includeFees:collection:updatedMinTimestamp:updatedMaxTimestamp:auxiliaryFeePercentages:auxiliaryFeeRecipients:)` has been added to ImmutableX instance.
- `getCollection(address:)` has been added to ImmutableX instance.
- `listCollectionFilters(address:pageSize:nextPageToken:)` has been added to ImmutableX instance.
- `listCollections(pageSize:cursor:orderBy:direction:blacklist:whitelist:keyword:)` has been added to ImmutableX instance.
- `getProject(id:signer:)` has been added to ImmutableX instance.
- `getProjects(pageSize:cursor:orderBy:direction:signer:)` has been added to ImmutableX instance.
- `getBalance(owner:address:)` has been added to ImmutableX instance.
- `listBalances(owner:)` has been added to ImmutableX instance.
- `getMint(id:)` has been added to ImmutableX instance.
- `listMints(pageSize:cursor:orderBy:direction:user:status:minTimestamp:maxTimestamp:tokenType:tokenId:assetId:tokenName:tokenAddress:minQuantity:maxQuantity:metadata:)` has been added to ImmutableX instance.
- `listWithdrawals(withdrawnToWallet:rollupStatus:pageSize:cursor:orderBy:direction:user:status:minTimestamp:maxTimestamp:tokenType:)tokenId:assetId:tokenAddress:tokenName:minQuantity:maxQuantity:metadata:)` has been added to ImmutableX instance.
- `getWithdrawal(id:)` has been added to ImmutableX instance.
- `getOrder(id:includeFees:auxiliaryFeePercentages:auxiliaryFeeRecipients:)` has been added to ImmutableX instance.
- `listOrders(pageSize:cursor:orderBy:direction:user:status:minTimestamp:maxTimestamp:updatedMinTimestamp:updatedMaxTimestamp:buyTokenType:buyTokenId:buyAssetId:buyTokenAddress:buyTokenName:buyMinQuantity:buyMaxQuantity:buyMetadata:sellTokenType:sellTokenId:sellAssetId:sellTokenAddress:sellTokenName:sellMinQuantity:sellMaxQuantity:sellMetadata:auxiliaryFeePercentages:auxiliaryFeeRecipients:includeFees:)` has been added to ImmutableX instance.
- `getTrade(id:)` has been added to ImmutableX instance.
- `listTrades(partyAOrderId:partyATokenType:partyATokenAddress:partyBOrderId:partyBTokenType:partyBTokenAddress:partyBTokenId:p)ageSize:cursor:orderBy:direction:minTimestamp:maxTimestamp:)` has been added to ImmutableX instance.
- `getToken(address:)` has been added to ImmutableX instance.
- `listTokens(address:symbols:)` has been added to ImmutableX instance.
- `getTransfer(id:)` has been added to ImmutableX instance.
- `listTransfers(pageSize:cursor:orderBy:direction:user:receiver:status:minTimestamp:maxTimestamp:tokenType:tokenId:assetId:tokenAddress:tokenName:minQuantity:maxQuantity:metadata:)` has been added to ImmutableX instance.
- `transfer(token:recipientAddress:signer:starkSigner:)` has been added to ImmutableX instance.
- `batchTransfer(transfers:signer:starkSigner:)` has been added to ImmutableX instance.
- `generateKeyPair()` method has been added to `StarkKey` for generating random key pairs.

### Changed

- (Breaking): renamed ImmutableX's `sell(orderId:fees:signer:starkSigner:)` to `createTrade(orderId:fees:signer:starkSigner:)`
- (Breaking): renamed ImmutableX's `buy(asset:sellToken:fees:signer:starkSigner:)` to `createOrder(asset:sellToken:fees:signer:starkSigner:)`

### Deprecated

for soon-to-be removed features.

### Removed

- (Breaking): removed closure based APIs from ImmutableX instance.

### Fixed

for any bug fixes.

## [0.4.0] - 2022-10-21

### Changed

- (Breaking): rename ImmutableXCore to ImmutableX
This follows the new spec for the core SDKs that will come to swift shortly.

- (Breaking): replace ropsten environment for sandbox
Ropsten has been deprecated and won't work anymore. Sandbox is the preferred testing environment.

- (Breaking): rename PrivateKey, PublicKey, KeyPair and CurvePoint to ECPrivateKey, ECPublicKey, ECKeyPair and ECCurvePoint respectively
The previous names were too generic and would easily conflict with other classes/structs. These have then been prefixed with EC for Elliptic Curve.

- (Breaking): rename StarkKey's generateKeyPair to generateLegacyKeyPair
This keypair generation is specific to ImmutableX's Link and should be used only for compatibility reasons.

### Fixed

- re-include macos as a Cocoapods target
The Core SDK is generic enough that it should work on macOS. It had accidentally been removed on 0.3.1.

## [0.3.1] - 2022-10-19

### Removed

- (Breaking): remove StarkKey's generateKeyPairFromRawSignature method from public interface 

- version file

### Changed

- Make PrivateKey, PublicKey, KeyPair and CurvePoint conform to Codable in order to make data persistence easier.
- secp256k dependency, since the previous one was deprecated on Cocoapods
- Swift 5.7 as minimum support

## [0.2.2] - 2022-08-17

### Removed

- SwiftLint as a Plugin. Since SPM doesn't support package alias for now, this plugin would conflict with apps that use 
it and try to import this library.

## [0.2.1] - 2022-08-11

### Fixed

- An incorrect ETH signature being passed in as part of the workflows.
- A crash in debug mode when using the optional log level `.requestBody`.

## [0.2.0] - 2022-08-11

### Added

Support to Cocoapods

## [0.1.0] - 2022-08-08

Initial release with a client for the public API and the following workflows:

Buy
Sell
Cancel sell
Transfer
Register
Buy crypto
