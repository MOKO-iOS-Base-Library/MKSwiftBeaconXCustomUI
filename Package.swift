// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MKSwiftBeaconXCustomUI",
    platforms: [
        .iOS(.v15),  // 最低支持iOS 15
    ],
    products: [
        .library(
            name: "MKSwiftBeaconXCustomUI",
            targets: ["MKSwiftBeaconXCustomUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKBaseSwiftModule.git", .upToNextMajor(from: "1.0.22")),
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKSwiftCustomUI.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MKSwiftBeaconXCustomUI",
            dependencies: [
                .product(name: "MKBaseSwiftModule",
                         package: "MKBaseSwiftModule"),
                .product(name: "MKSwiftCustomUI",
                         package: "MKSwiftCustomUI")
            ],
            path: "Sources",
            resources: [
                .process("Assets")
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("IOS15_OR_LATER")  // 添加编译标志
            ]
        ),
        .testTarget(
            name: "MKSwiftBeaconXCustomUITests",
            dependencies: ["MKSwiftBeaconXCustomUI"])
    ]
)
