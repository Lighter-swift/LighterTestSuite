//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Lighter
@testable import ContactsTestDB

final class RecordFindTests: XCTestCase {
  
  let db = ContactsDB.module!
  
  func testPrimaryKeyFind() throws {
    let dago = try XCTUnwrap(try db.people.find(2))
    XCTAssertEqual(dago.firstname, "Dagobert")
    XCTAssertEqual(dago.lastname,  "Duck")
  }

  func testColumnFind() throws {
    let dago = try XCTUnwrap(try db.people.find(by: \.firstname, "Dagobert"))
    XCTAssertEqual(dago.firstname, "Dagobert")
    XCTAssertEqual(dago.lastname,  "Duck")
  }  
}
