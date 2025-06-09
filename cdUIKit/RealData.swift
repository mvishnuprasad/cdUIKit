//
//  RealData.swift
//  cdUIKit
//
//  Created by vishnuprasad on 09/06/25.
//

import Foundation
import RealmSwift

class TodoData: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isDone : Bool = false
    /// inverse relation
    var parent = LinkingObjects(fromType: CatData.self, property: "items")
}
class CatData: Object {
    @objc dynamic var name : String = ""
    ///forward relationship
    let items = List<TodoData>()
}

