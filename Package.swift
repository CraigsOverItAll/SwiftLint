// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftLint",
    products: [
        .executable(name: "swiftlint", targets: ["swiftlint"]),
        .library(name: "SwiftLintFramework", targets: ["SwiftLintFramework"])
    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.13.0"),
        .package(url: "https://github.com/jpsim/SourceKitten.git", from: "0.21.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "0.7.0"),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "swiftlint",
            dependencies: [
                "Commandant",
                "SwiftLintFramework",
                "SwiftyTextTable",
            ]
        ),
        .target(
            name: "SwiftLintFramework",
            dependencies: [
                "SourceKittenFramework",
                "Yams",
            ]
        ),
        .testTarget(
            name: "SwiftLintFrameworkTests",
            dependencies: [
                "SwiftLintFramework"
            ],
            exclude: [
                "Resources",
            ]
        )
    ],
    swiftLanguageVersions: [3, 4]
)
