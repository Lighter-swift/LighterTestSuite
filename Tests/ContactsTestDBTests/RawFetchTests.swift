//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Foundation
import SQLite3
@testable import Lighter // if not re-exporting
@testable import ContactsTestDB

final class RawFetchTests: XCTestCase {
  
  let db = ContactsDB.loadIntoMemoryForTesting(
    Bundle.module.url(forResource: "ContactsDB", withExtension: "sqlite3")!
  )
  
  
  // MARK: - Record Fetches
  
  func testRawSQLFetch() throws {
    let persons =
    try db.people.fetch(verbatim: "SELECT * FROM person")
    XCTAssertEqual(persons.count, 3)
  }
  
  func testSQLInterpolationFetch() throws {
    let name    = "Dagobert"
    let persons = try db.people.fetch(
      sql: "SELECT * FROM person WHERE firstname = \(name)"
    )
    XCTAssertEqual(persons.count, 1)
  }
  
  
  // MARK: - Raw Record Fetches
  
  func testRawRecordFetch() throws {
    // let persons = Person.fetch(from: testDB) // Type based version
    let people = sqlite3_people_fetch(db.testDatabaseHandle)
    XCTAssertNotNil(people)
    XCTAssertEqual(people?.count, 3)
  }
  
  func testRawRecordFetchWithFilter() throws {
    let people = sqlite3_people_fetch(db.testDatabaseHandle) {
      $0.lastname == "Duck"
    }
    XCTAssertNotNil(people)
    XCTAssertEqual(people?.count, 2)
  }
  
  func testRawRecordFind() throws {
    // let person = Person.find(2, in: testDB) // Type based version
    let person = sqlite3_person_find(db.testDatabaseHandle, 2)
    XCTAssertNotNil(person)
    XCTAssertEqual(person?.lastname, "Duck")
    XCTAssertEqual(person?.firstname, "Donald")
    XCTAssertEqual(person?.id, 1)
  }
  
  
  func testBasicRecordFetch() throws {
    var matchCount = 0
    
    let people = try XCTUnwrap(
      sqlite3_people_fetch(db.testDatabaseHandle) {
        matchCount += 1 // side effect
        //print("MATCH:", $0)
        return $0.firstname == "Dagobert"
      }
    )
    //print("Persons:", persons)
    
    XCTAssertEqual(people.count, 1)
    XCTAssertEqual(people.first?.lastname,  "Duck")
    XCTAssertEqual(people.first?.firstname, "Dagobert")
    XCTAssertEqual(people.first?.id,  2)
    
    XCTAssertEqual(matchCount, 3) // not required I suppose?
  }
  
  func testRecordFetchWithSorting() throws {
    // We can just sort in Swift, SQLite doesn't really gain us much here?
    // Well, it might w/ `LIMIT`
    var matchCount = 0
    
    let persons = try XCTUnwrap(
      sqlite3_people_fetch(db.testDatabaseHandle) {
        matchCount += 1 // side effect
        return $0.lastname.hasPrefix("D") || $0.firstname == "Mickey"
      }
    )
    .sorted { $0.lastname > $1.lastname }

    //print("Persons:", persons)
    
    XCTAssertEqual(persons.count, 3)
    XCTAssertEqual(persons.first?.lastname, "Mouse")
    XCTAssertEqual(persons.first?.id,       3)
    
    XCTAssertEqual(matchCount, 3) // not required I suppose?
  }
}
