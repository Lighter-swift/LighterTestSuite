//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Foundation
import SQLite3
@testable import Lighter // if not re-exporting
@testable import ContactsTestDB

final class RawUpdateTests: XCTestCase {
  
  let db = ContactsDB.loadIntoMemoryForTesting(
    Bundle.module.url(forResource: "ContactsDB", withExtension: "sqlite3")!
  )
  
  func testRawPersonInsert() throws {
    try XCTSkipUnless(sqlite3_libversion_number() >= 3035000,
                      "This test requires SQLite 3.35+")
    var statement : OpaquePointer?
  
    let ok = sqlite3_prepare_v2(
      db.testDatabaseHandle,
      "INSERT INTO person ( lastname, firstname ) VALUES ( ?, ? ) RETURNING *",
      -1, &statement, nil
    )
    XCTAssertEqual(ok, SQLITE_OK)
    defer { sqlite3_finalize(statement) }

    let donald = Person(id: 0, firstname: "Blab", lastname: "Blub")
    donald.bind(to: statement,
                indices: (idx_id: -1, idx_firstname: 2, idx_lastname: 1))
    {
      let res = sqlite3_step(statement)
      XCTAssertEqual(res, SQLITE_ROW)
      
      let insertedDonald = Person(statement)
      XCTAssertEqual(donald.lastname,  insertedDonald.lastname)
      XCTAssertEqual(donald.firstname, insertedDonald.firstname)
      XCTAssertEqual(donald.id, 0)
      XCTAssertEqual(insertedDonald.id, 4)
    }
  }
  
  func testRawPersonRecordInsert() throws {
    let base   = Person(id: 0, firstname: "Blab", lastname: "Blub")
    var person = base
    let rc = sqlite3_person_insert(db.testDatabaseHandle, &person)
    //let rc = person.insert(into: testDB) // type based variant
    XCTAssertEqual(rc, SQLITE_OK)
    XCTAssertEqual(base.lastname,  person.lastname)
    XCTAssertEqual(base.firstname, person.firstname)
    XCTAssertEqual(base.id,   0)
    XCTAssertEqual(person.id, 4)
  }
  
  func testRawPersonRecordInsertNoReturning() throws {
    let old = ContactsDB.useInsertReturning
    ContactsDB.useInsertReturning = false
    defer { ContactsDB.useInsertReturning = old }

    let base   = Person(id: 0, firstname: "Blab", lastname: "Blub")
    var person = base
    let rc = sqlite3_person_insert(db.testDatabaseHandle, &person)
    //let rc = person.insert(into: testDB) // type based variant
    XCTAssertEqual(rc, SQLITE_OK)
    XCTAssertEqual(base.lastname,  person.lastname)
    XCTAssertEqual(base.firstname, person.firstname)
    XCTAssertEqual(base.id,   0)
    XCTAssertEqual(person.id, 4)
  }

  func testRawPersonUpdate() throws {
    let newValues = Person(id: 3, firstname: "Minney", lastname: "Mouse")
    
    var statement : OpaquePointer?
    let ok = sqlite3_prepare_v2(
      db.testDatabaseHandle,
      "UPDATE person SET lastname = ?, firstname = ? WHERE person_id = ?",
      -1, &statement, nil
    )
    XCTAssertEqual(ok, SQLITE_OK)
    defer { sqlite3_finalize(statement) }

    newValues.bind(to: statement,
      indices: ( idx_id: 3, idx_firstname: 2, idx_lastname: 1 )
    ) {
      sqlite3_step(statement)
    }

    let people = try db.people.fetch { $0.id == newValues.id }
    //print("Persons:", persons)
    XCTAssertEqual(people.count, 1)
    
    if let idMatch = people.first {
      XCTAssertEqual(idMatch, newValues)
    }
  }
}
