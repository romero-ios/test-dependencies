// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "test-dependencies",
    defaultLocalization: "en",
    platforms: [
      .iOS(.v17)
    ],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "SomeClient", targets: ["SomeClient"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),

    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "SomeClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "SomeClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                "AppFeature"
            ]
        )
    ]
)
