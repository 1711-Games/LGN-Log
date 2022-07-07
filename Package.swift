// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "LGNLog",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "LGNLog",
            targets: ["LGNLog"]
        ),
        .library(
            name: "LGNLogVapor",
            targets: ["LGNLogVapor"]
        )
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
        .target(
            name: "LGNLogVapor",
            dependencies: ["LGNLog"],
            path: "Sources/LGNLog+Vapor"
        ),
        .testTarget(
            name: "LGNLogTests",
            dependencies: ["LGNLog"]
        ),
    ]
)
