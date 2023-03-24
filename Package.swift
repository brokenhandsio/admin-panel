// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AdminPanel",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "AdminPanel",
            targets: ["AdminPanel"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nodes-vapor/flash.git", branch: "master"),
        .package(url: "https://github.com/nodes-vapor/submissions.git", from: "3.0.0-rc.6"),
        .package(url: "https://github.com/vapor-community/mailgun.git", from: "5.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0"),
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
                .product(name: "Submissions", package: "submissions"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt")
            ]),
        .testTarget(
            name: "AdminPanelTests",
            dependencies: ["AdminPanel"]),
    ]
)
