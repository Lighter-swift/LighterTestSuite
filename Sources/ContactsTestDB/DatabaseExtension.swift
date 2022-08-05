//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

import Lighter

extension ContactsDB {
  
  #if swift(>=5.7)
  public var _allRecordTypes : [ any SQLRecord.Type ] { [
    Self.recordTypes.people,
    Self.recordTypes.addresses,
    Self.recordTypes.aFancyTestTables,
    Self.recordTypes.aTestViews
  ] }
  public var _allTableRecordTypes : [ any SQLTableRecord.Type ] { [
    Self.recordTypes.people,
    Self.recordTypes.addresses,
    Self.recordTypes.aFancyTestTables
    //Self.recordTypes.aTestViews // invalid
  ] }
  #endif // swift(>=5.7)
}
