//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Foundation
@testable import Lighter
@testable import ContactsTestDB

final class RecordTransactionTests: XCTestCase {
  
  let db = ContactsDB.loadIntoMemoryForTesting(
    Bundle.module.url(forResource: "ContactsDB", withExtension: "sqlite3")!
  )
  
  func testReadOnly() throws {
    try db.readTransaction { tx in
      let dago = try XCTUnwrap(try tx.people.find(2))
      XCTAssertEqual(dago.firstname, "Dagobert")
      XCTAssertEqual(dago.lastname,  "Duck")

      let mickey = try XCTUnwrap(try tx.people.find(3))
      XCTAssertEqual(mickey.firstname, "Mickey")
      XCTAssertEqual(mickey.lastname,  "Mouse")
    }
    
    let newDago = try XCTUnwrap(try db.people.find(2))
    XCTAssertEqual(newDago.lastname, "Duck")
  }
  
  func testSimpleChange() throws {
    try db.transaction { tx in
      var dago = try XCTUnwrap(try tx.people.find(2))
      XCTAssertEqual(dago.firstname, "Dagobert")
      XCTAssertEqual(dago.lastname,  "Duck")
      
      dago.lastname = "Ducky"
      try tx.update(dago)
    }
    
    let newDago = try XCTUnwrap(try db.people.find(2))
    XCTAssertEqual(newDago.lastname, "Ducky")
  }

  func testSomeChange() throws {
    try db.transaction { tx in
      let count = try tx.people.fetchCount()
      XCTAssertEqual(count, 3)
      
      var dago = try XCTUnwrap(try tx.people.find(2))
      XCTAssertEqual(dago.firstname, "Dagobert")
      XCTAssertEqual(dago.lastname,  "Duck")
      
      dago.lastname = "Ducky"
      try tx.update(dago)
      
      try tx.delete(dago)
      let countAfterDelete = try tx.people.fetchCount()
      XCTAssertEqual(countAfterDelete, 2)
      
      let newDago = try tx.insert(dago) // gets new ID!
      let countAfterInsert = try tx.people.fetchCount()
      XCTAssertEqual(countAfterInsert, 3)
      XCTAssertEqual(newDago.id,       4)
    }
    
    XCTAssertNil(try db.people.find(2)) // old dago got deleted
    
    let newDago = try XCTUnwrap(try db.people.find(4))
    XCTAssertEqual(newDago.lastname, "Ducky")
  }

  func testExclusiveChange() throws {
    try db.transaction(mode: .exclusive) { tx in
      var dago = try XCTUnwrap(try tx.people.find(2))
      XCTAssertEqual(dago.firstname, "Dagobert")
      XCTAssertEqual(dago.lastname,  "Duck")
      
      dago.lastname = "Ducky"
      try tx.update(dago)
    }
    
    let newDago = try XCTUnwrap(try db.people.find(2))
    XCTAssertEqual(newDago.lastname, "Ducky")
  }
  
  func testRollbackOnError() throws {
    struct DummyError: Swift.Error {}
    
    XCTAssertThrowsError(
      try db.transaction { tx in
        var dago = try XCTUnwrap(try tx.people.find(2))
        XCTAssertEqual(dago.firstname, "Dagobert")
        XCTAssertEqual(dago.lastname,  "Duck")
        
        dago.lastname = "Ducky"
        try tx.update(dago)

        let newDago = try XCTUnwrap(try tx.people.find(2))
        XCTAssertEqual(newDago.lastname, "Ducky")
        
        throw DummyError()
      }
    )
    { error in
      XCTAssertTrue(error is DummyError)
    }

    let newDago = try XCTUnwrap(try db.people.find(2))
    XCTAssertEqual(newDago.lastname, "Duck")
  }
}
