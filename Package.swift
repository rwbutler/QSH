// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "QSH",
    platforms: [
        .macOS(.v10_10)
    ],
    products: [
        .executable(
            name: "qsh",
            targets: ["QSH"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "0.2.1"
        ),
        .package(
            url: "https://github.com/JohnSundell/ShellOut",
            from: "2.3.0"
        ),
        .package(
            url: "https://github.com/rwbutler/swift-quiz",
            from: "0.0.1"
        )
    ],
    targets: [
        .target(
            name: "QSH",
            dependencies: ["ArgumentParser", "ShellOut", "SwiftQuiz"],
            path: "code"
        )
    ]
)
