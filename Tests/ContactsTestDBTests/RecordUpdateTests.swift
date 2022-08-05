//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Foundation
@testable import Lighter // if not re-exporting
@testable import ContactsTestDB

final class RecordUpdateTests: XCTestCase {
  
  let db = ContactsDB.loadIntoMemoryForTesting(
    Bundle.module.url(forResource: "ContactsDB", withExtension: "sqlite3")!
  )

  func testPersonInsert() throws {
    let donald = Person(id: 0, firstname: "Blab", lastname: "Blub")
    
    let insertedDonald = try db.insert(donald)
    XCTAssertEqual(donald.lastname,  insertedDonald.lastname)
    XCTAssertEqual(donald.firstname, insertedDonald.firstname)
    XCTAssertEqual(donald        .id, 0)
    XCTAssertEqual(insertedDonald.id, 4)
    
    let lookup = try XCTUnwrap(try db.people.find(4))
    XCTAssertEqual(insertedDonald, lookup)
  }
  
  func testPersonUpdate() throws {
    let newValues = Person(id: 3, firstname: "Minney", lastname: "Mouse")
    try db.update(newValues)

    let lookup = try XCTUnwrap(try db.people.find(3))
    XCTAssertEqual(newValues, lookup)
  }
}
