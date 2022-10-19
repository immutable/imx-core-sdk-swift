# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

for added features.

### Changed

for changed features.

### Deprecated

for soon-to-be removed features.

### Removed

for now removed features.

### Fixed

for any bug fixes.

## [0.3.1] - 2022-10-19

### Removed

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
