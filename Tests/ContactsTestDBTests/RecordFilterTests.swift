//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Lighter
@testable import ContactsTestDB

final class RecordFilterTests: XCTestCase {
  
  let db = ContactsDB.module!
  
  func testSimpleQuery() throws {
    var matchCount = 0
    
    let people = try db.people.filter {
      matchCount += 1 // side effect
      //print("MATCH:", $0)
      return $0.firstname == "Dagobert"
    }

    //print("Persons:", persons)
    
    XCTAssertEqual(people.count, 1)
    XCTAssertEqual(people.first?.lastname,  "Duck")
    XCTAssertEqual(people.first?.firstname, "Dagobert")
    XCTAssertEqual(people.first?.id,  2)
    
    XCTAssertEqual(matchCount, 3) // not required I suppose?
  }
}
