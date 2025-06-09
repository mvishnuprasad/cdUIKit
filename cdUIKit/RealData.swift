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
    
}
