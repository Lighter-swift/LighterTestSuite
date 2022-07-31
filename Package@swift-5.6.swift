// swift-tools-version:5.6

import PackageDescription

var package = Package(
  name: "LighterTestSuite",

  platforms: [ .macOS(.v10_15), .iOS(.v13) ],
  products: [],
  
  dependencies: [
    .package(url: "git@github.com:55DB091A-8471-447B-8F50-5DFF4C1B14AC/Lighter.git",
             branch: "develop")
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
