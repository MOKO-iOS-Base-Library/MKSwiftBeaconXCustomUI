// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MKSwiftBeaconXCustomUI",
    platforms: [
        .iOS(.v15),  // 最低支持iOS 15
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MKSwiftBeaconXCustomUI",
            targets: ["MKSwiftBeaconXCustomUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MOKO-iOS-Base-Library/MKBaseSwiftModule.git", .upToNextMajor(from: "1.0.9")),
    ],
    targets: [
        .target(
            name: "MKSwiftBeaconXCustomUI",
            dependencies: [
                .product(name: "MKBaseSwiftModule",
                         package: "MKBaseSwiftModule")
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
