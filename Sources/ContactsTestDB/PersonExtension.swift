//
//  Created by Helge Heß.
//  Copyright © 2022 ZeeZide GmbH.
//

extension Person {
  
  var fullName : String {
    guard let fn = firstname, !fn.isEmpty else { return lastname }
    guard !lastname.isEmpty else { return fn }
    return "\(fn) \(lastname)"
  }
}
