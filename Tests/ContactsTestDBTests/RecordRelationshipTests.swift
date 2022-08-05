//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Foundation
import SQLite3
import Lighter
@testable import ContactsTestDB

final class RecordRelationshipTests: XCTestCase {
  
  let db = ContactsDB.module!
  
  #if false // this `fetch` imp lacks the non-optional/optional mix variants
  func testPersonIDsLookup() throws {
    let people    = try db.select(from: \.people, \.id)
    let addresses = try db.addresses.fetch(for: \.personId, in: people,
                                           omitEmpty: false)
    //print("Results:", addresses)
    XCTAssertEqual(addresses.count, 3)
  }
  func testPersonIDsLookupOmitEMtpy() throws {
    let people    = try db.select(from: \.people, \.id)
    let addresses = try db.addresses.fetch(for: \.personId, in: people,
                                           omitEmpty: true)
    //print("Results:", addresses)
    XCTAssertEqual(addresses.count, 1)
  }

  func testPersonsLookup() throws {
    let people    = try db.people.fetch()
    let addresses = try db.addresses.fetch(for: \.personId, in: people,
                                           omitEmpty: false)
    //print("Results:", addresses)
    XCTAssertEqual(addresses.count, 3)
  }
  #endif

  func testPersonLookup() throws {
    let address = try XCTUnwrap(try db.addresses.find(1))
    let person  = try XCTUnwrap(
      db.addresses.findTarget(for: \.personId, in: address)
    )
    XCTAssertEqual(person.id, address.personId)
    //print("Person:", person, "for:", address)
  }
  
  func testAddressLookup() throws {
    do {
      let person    = try XCTUnwrap(try db.people.find(2))
      let addresses = try db.addresses.fetch(for: \.personId, in: person)
      XCTAssertEqual(addresses.count, 1)
    }
    do {
      let person    = try XCTUnwrap(try db.people.find(1))
      let addresses = try db.addresses.fetch(for: \.personId, in: person)
      XCTAssertTrue(addresses.isEmpty)
    }
  }
  
  
  // MARK: - Generated API tests

  func testDirectExplicitPersonLookup() throws {
    let address = try XCTUnwrap(try db.addresses.find(1))
    let person  = try XCTUnwrap(db.people.find(for: address))
    XCTAssertEqual(person.id, address.personId)
    //print("Person:", person, "for:", address)
  }
  
  func testDirectExplicitAddressLookup() throws {
    do {
      let person    = try XCTUnwrap(try db.people.find(2))
      let addresses = try db.addresses.fetch(for: person) // short
      XCTAssertEqual(addresses.count, 1)
    }
    do {
      let person    = try XCTUnwrap(try db.people.find(1))
      let addresses = try db.addresses.fetch(for: person)
      XCTAssertTrue(addresses.isEmpty)
    }
  }

  func testExplicitPersonLookup() throws {
    let address = try XCTUnwrap(try db.addresses.find(1))
    let person  = try XCTUnwrap(db.people.find(for: address))
    XCTAssertEqual(person.id, address.personId)
    //print("Person:", person, "for:", address)
  }
  
  func testExplicitAddressLookup() throws {
    do {
      let person    = try XCTUnwrap(try db.people.find(2))
      let addresses = try db.addresses.fetch(for: person)
      XCTAssertEqual(addresses.count, 1)
    }
    do {
      let person    = try XCTUnwrap(try db.people.find(1))
      let addresses = try db.addresses.fetch(for: person)
      XCTAssertTrue(addresses.isEmpty)
    }

    #if false // this `fetch` imp lacks the non-optional/optional mix variants
    do {
      let persons   = try db.people.fetch()
      // this isn't generated yet:
      #if false
        let addresses = try db.addresses.fetch(for: persons)
      #else
        let addresses = try db.addresses.fetch(for: \.personId, in: persons)
      #endif
      XCTAssertEqual(addresses.count, 3)
    }
    #endif
  }
}
