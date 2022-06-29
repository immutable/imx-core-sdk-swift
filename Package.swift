// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .target(
            name: "IMXCoreSDK",
            dependencies: []
        ),
        .testTarget(
            name: "IMXCoreSDKTests",
            dependencies: ["IMXCoreSDK"]
        ),
    ]
)
