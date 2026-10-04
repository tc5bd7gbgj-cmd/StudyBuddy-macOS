// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "StudyBuddyApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "StudyBuddyApp",
            targets: ["StudyBuddyApp"]
        )
    ],
    targets: [
        .executableTarget(
            name: "StudyBuddyApp",
            path: "Sources/StudyBuddyApp"
        )
    ]
)
