//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Foundation
@testable import Lighter // if not re-exporting
@testable import ContactsTestDB

final class FetchTests: XCTestCase {
  
  let db = ContactsDB.module!
  
  func testFetchCount() throws {
    do {
      let count = try db.people.fetchCount()
      XCTAssertEqual(count, 3)
    }
    do {
      let count = try db.people.fetchCount { $0.lastname == "Duck" }
      XCTAssertEqual(count, 2)
    }
    do {
      let count = try db.people.fetchCount { $0.firstname == nil }
      XCTAssertEqual(count, 0)
    }
    do {
      let count = try db.people.fetchCount { $0.firstname != nil }
      XCTAssertEqual(count, 3)
    }
  }
  
  // MARK: - Array Results
  
  func testBoundInterpolationPersonFetch() throws {
    let name = "Dagobert"
    let persons = try db.people.fetch {
      $0.id == 2
      && "firstname = \(name)"
      && "\($0.firstname) = \(name)"
      && SQLInterpolatedPredicate("firstname = \(name)")
    }
    //print("Persons:", persons)
    XCTAssertEqual(persons.count, 1)
  }
  
  func testQualifiedBoundPersonFetch() throws {
    // Note: Doesn't actually fail on a missing binding!
    let persons = try db.people.fetch {
      $0.id == 2 && $0.firstname == "Dagobert"
    }
    //print("Persons:", persons)
    XCTAssertEqual(persons.count, 1)
  }
  
  func testQualifiedLiteralPersonFetch() throws {
    let persons = try db.people.fetch {
      $0.id == 2
    }
    //print("Persons:", persons)
    XCTAssertEqual(persons.count, 1)
  }
  
  func testPersonFetch() throws {
    let persons = try db.people.fetch()
    //print("Persons:", persons)
    XCTAssertEqual(persons.count, 3)
  }
  
  func testPersonFetchWithSort() throws {
    let persons = try db.people.fetch(orderBy: \.firstname, .descending)
    //print("Persons:", persons)
    XCTAssertEqual(persons.map(\.firstname), [ "Mickey", "Donald", "Dagobert" ])
  }

  func testPersonFetchWithSort2() throws {
    let persons = try db.people.fetch(orderBy: \.lastname, .ascending,
                                                \.firstname, .descending)
    { _ in
      SQLTruePredicate.shared
    }
    //print("Persons:", persons)
    XCTAssertEqual(persons.map(\.firstname), [ "Donald", "Dagobert", "Mickey" ])
  }
  
  func testPersonFilter() throws {
    let persons = try db.people.filter {
      $0.id >= 2
    }
    XCTAssertEqual(persons.count, 2)
    //print("Persons:", persons)
  }
}
