// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "admin-panel",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "AdminPanel", targets: ["AdminPanel"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nodes-vapor/flash.git", branch: "master"),
        .package(url: "https://github.com/vapor-community/mailgun.git", from: "5.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
        .package(url: "https://github.com/brokenhandsio/leaf-bootstrap.git", from: "1.0.0-beta")
    ],
    targets: [
        .target(
            name: "AdminPanel", 
            dependencies: [
                .product(name: "Flash", package: "flash"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Mailgun", package: "mailgun"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "LeafBootstrap", package: "leaf-bootstrap")
            ],
            resources: [
                .copy("Views/"),
                .copy("Public/"),
            ]
        ),
        .testTarget(
            name: "AdminPanelTests",
            dependencies: [.target(name: "AdminPanel")]
        ),
    ]
)
