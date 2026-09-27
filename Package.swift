// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LumiSettings",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "ProviderSettingView", targets: ["ProviderSettingView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CofficLab/LumiUI.git", from: "1.7.0"),
    ],
    targets: [
        .target(
            name: "ProviderSettingView",
            dependencies: [.product(name: "LumiUI", package: "LumiUI")]
        ),
        .testTarget(
            name: "ProviderSettingViewTests",
            dependencies: ["ProviderSettingView"]
        ),
    ]
)
