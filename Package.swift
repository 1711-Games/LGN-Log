// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "LGNLog",
    products: [
        .library(
            name: "LGNLog",
            targets: ["LGNLog"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
    ],
    targets: [
        .target(
            name: "LGNLog",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ]
        ),
        .testTarget(
            name: "LGNLogTests",
            dependencies: ["LGNLog"]
        ),
    ]
)
