//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import XCTest
import Lighter
@testable import ContactsTestDB

final class RecordFetchTests: XCTestCase {
  
  let db = ContactsDB.module!
  
  // MARK: - Counts
  
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
    let people = try db.people.fetch {
      $0.id == 2 && $0.firstname == "Dagobert"
    }
    //print("Persons:", people)
    XCTAssertEqual(people.count, 1)
  }
  
  func testQualifiedLiteralPersonFetch() throws {
    let people = try db.people.fetch {
      $0.id == 2
    }
    //print("Persons:", persons)
    XCTAssertEqual(people.count, 1)
  }
  
  func testPersonFetch() throws {
    let people = try db.people.fetch()
    //print("Persons:", persons)
    XCTAssertEqual(people.count, 3)
  }
  
  func testPersonFetchWithSort() throws {
    let people = try db.people.fetch(orderBy: \.firstname, .descending)
    //print("Persons:", persons)
    XCTAssertEqual(people.map(\.firstname), [ "Mickey", "Donald", "Dagobert" ])
  }

  func testPersonFetchWithSort2() throws {
    let people = try db.people.fetch(orderBy: \.lastname, .ascending,
                                                \.firstname, .descending)
    { _ in
      SQLTruePredicate.shared
    }
    //print("Persons:", persons)
    XCTAssertEqual(people.map(\.firstname), [ "Donald", "Dagobert", "Mickey" ])
  }
  
  func testPersonFilter() throws {
    let people = try db.people.filter {
      $0.id >= 2
    }
    XCTAssertEqual(people.count, 2)
    //print("Persons:", people)
  }
}
