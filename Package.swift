// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "cloud_sdk_ios_sourcery_utils",
    platforms: [.macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "cloud_sdk_ios_sourcery_utils",
            type: .dynamic,
            targets: ["cloud_sdk_ios_sourcery_utils"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "Sourcery", url: "https://github.com/krzysztofzablocki/Sourcery.git", .exact("1.0.2")),
        .package(url: "https://github.com/apple/swift-algorithms", .upToNextMinor(from: "0.0.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "cloud_sdk_ios_sourcery_utils",
            dependencies: [.product(name: "SourceryRuntime", package: "Sourcery"),
                           .product(name: "Algorithms", package: "swift-algorithms")]),
        .testTarget(
            name: "cloud_sdk_ios_sourcery_utilsTests",
            dependencies: ["cloud_sdk_ios_sourcery_utils"])
    ]
)
