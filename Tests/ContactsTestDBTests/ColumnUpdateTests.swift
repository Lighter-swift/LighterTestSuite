//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Foundation
@testable import Lighter // if not re-exporting
@testable import ContactsTestDB

final class ContactsColumnUpdateTests: XCTestCase {
  
  let db = ContactsDB.loadIntoMemoryForTesting(
     Bundle.module.url(forResource: "ContactsDB", withExtension: "sqlite3")!
  )

  func testBasicInsert() throws {
    try db.insert(into: \.people, \.id, \.firstname, \.lastname,
                  values: 10, nil, "Topper")
    
    let lookup = try XCTUnwrap(try db.people.find(10))
    XCTAssertEqual(lookup.id, 10)
    XCTAssertEqual(lookup.lastname, "Topper")
    XCTAssertNil  (lookup.firstname)
  }
  
  func testBasicUpdateWithQualifier() throws {
    try db.update(\.people,
                  set: \.lastname,  to: "Topper",
                  set: \.firstname, to: nil)
    {
      $0.id == 1
    }

    let lookup = try XCTUnwrap(try db.people.find(1))
    XCTAssertEqual(lookup.id, 1)
    XCTAssertEqual(lookup.lastname, "Topper")
    XCTAssertNil  (lookup.firstname)
  }
  
  func testBasicUpdateWithPrimaryKey() throws {
    try db.update(\.people,
                  set: \.lastname,   to: "Topper",
                  set: \.firstname,  to: nil,
                  where: \.id, is: 1)

    let lookup = try XCTUnwrap(try db.people.find(1))
    XCTAssertEqual(lookup.id, 1)
    XCTAssertEqual(lookup.lastname, "Topper")
    XCTAssertNil  (lookup.firstname)
  }
}
