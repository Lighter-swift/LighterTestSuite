// swift-tools-version:5.7

import PackageDescription

var package = Package(
  name: "LighterTestSuite",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  
  dependencies: [
    .package(url: "https://github.com/Lighter-swift/Lighter.git", from: "1.0.2")
  ],
  
  targets: [
    .target(name         : "ContactsTestDB",
            dependencies : [ "Lighter" ],
            exclude      : [ "README.md",
                             "SubDir/OtherDB-v001.sql",
                             "SubDir/OtherDB-v002.sql",
                             "SubDir/OtherDB-v003.sql",
                             "NoSQL/CrashTestDummy.sql" ],
            resources    : [ .copy("ContactsDB.sqlite3"),
                             .copy("ContactsDB-AddView.sql") ],
            plugins      : [ .plugin(name: "Enlighter", package: "Lighter") ]),
            
    // MARK: - Tests
    
    .testTarget(name: "ContactsTestDBTests",
                dependencies: [ "Lighter", "ContactsTestDB" ])
    
  ]
)
