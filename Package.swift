// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SetFolderIcon",
    products: [
        .executable(
            name: "seticon",
            targets: ["seticon"])
    ],
    targets: [
        .target(
            name: "seticon",
            dependencies: [])
    ]
)
