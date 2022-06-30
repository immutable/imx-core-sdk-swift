// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.
// swiftlint:disable line_length

import PackageDescription

let package = Package(
    name: "IMXCoreSDK",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "IMXCoreSDK",
            targets: ["IMXCoreSDK"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/juozasvalancius/SwiftLint/releases/download/spm-accommodation/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "cdc36c26225fba80efc3ac2e67c2e3c3f54937145869ea5dbcaa234e57fc3724"
        ),
        .plugin(
            name: "SwiftLintXcode",
            capability: .buildTool(),
            dependencies: ["SwiftLintBinary"]
        ),
        .target(
            name: "IMXCoreSDK",
            dependencies: [],
            plugins: ["SwiftLintXcode"]
        ),
        .testTarget(
            name: "IMXCoreSDKTests",
            dependencies: ["IMXCoreSDK"]
        ),
    ]
)
