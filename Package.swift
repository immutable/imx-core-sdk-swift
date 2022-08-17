// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImmutableXCore",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "ImmutableXCore",
            targets: ["ImmutableXCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.5"),
        .package(url: "https://github.com/attaswift/BigInt", from: "5.3.0"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.6"),
    ],
    targets: [
        .target(
            name: "ImmutableXCore",
            dependencies: [
                .product(name: "BigInt", package: "BigInt"),
                .product(name: "AnyCodable", package: "AnyCodable"),
                .product(name: "secp256k1", package: "secp256k1.swift"),
            ],
            resources: [
                .copy("version"),
            ]
        ),
        .testTarget(
            name: "ImmutableXCoreTests",
            dependencies: [
                .target(name: "ImmutableXCore"),
                .product(name: "BigInt", package: "BigInt"),
            ]
        ),
    ]
)
