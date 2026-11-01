// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SM2Scheduler",
    platforms: [.iOS("26.0")],
    products: [.library(name: "SM2Scheduler", targets: ["SM2Scheduler"])],
    targets: [.target(name: "SM2Scheduler"), .testTarget(name: "SM2SchedulerTests", dependencies: ["SM2Scheduler"])]
)
