// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ProviderManager",
  platforms: [
    .iOS(.v12),
    .tvOS(.v10),
    .watchOS(.v5)
  ],
  products: [
    .library(
      name: "ProviderManager",
      targets: ["ProviderManager"]),
    .library(
      name: "ProviderManagerFirebase",
      type: .dynamic,
      targets: ["ProviderManagerFirebase"])
  ],
  dependencies: [],
  targets: [
    .target(name: "ProviderManager",
            dependencies: []),
    .target(name: "ProviderManagerFirebase",
            dependencies: ["ProviderManager"])
  ]
)
