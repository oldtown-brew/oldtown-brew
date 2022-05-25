// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "OldtownBrew",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "OldtownBrew",
            targets: ["OldtownBrew"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.9.0")
    ],
    targets: [
        .executableTarget(
            name: "OldtownBrew",
            dependencies: ["Publish"]
        )
    ]
)
