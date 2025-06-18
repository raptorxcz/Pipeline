// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pipeline",
    platforms: [.macOS(.v13), .iOS(.v16), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "Pipeline",
            targets: ["Pipeline"]
        ),
        .library(
            name: "PipelineTestDoubles",
            targets: ["PipelineTestDoubles"]
        )
    ],
    targets: [
        .target(
            name: "Pipeline"
        ),
        .target(
            name: "PipelineTestDoubles",
            dependencies: ["Pipeline"],
            path: "Tests/PipelineTestDoubles"
        ),
        .testTarget(
            name: "PipelineTests",
            dependencies: [
                "Pipeline",
                "PipelineTestDoubles"
            ]
        )
    ]
)
