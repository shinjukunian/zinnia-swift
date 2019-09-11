// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Zinnia-Swift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Zinnia-Swift",
            targets: ["Zinnia-Swift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.

        .target(
            name: "Zinnia-Swift",
            dependencies: ["zinnia"]),
        
        .target(name: "zinnia",
                dependencies: [],
                path: nil,
                exclude: [String](),
                sources: ["character.cpp",
                          "feature.cpp",
                          "libzinnia.cpp",
                          "param.cpp",
                          "recognizer.cpp",
                          "sexp.cpp",
                          "svm.cpp",
                          "trainer.cpp"],
                publicHeadersPath: nil,
                cSettings: [.define("HAVE_CONFIG_H")],
                cxxSettings: nil,
                swiftSettings: nil,
                linkerSettings: nil),
        
        .testTarget(
            name: "Zinnia-SwiftTests",
            dependencies: ["Zinnia-Swift"]),
        

    ]
)
