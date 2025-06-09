//
//  model.swift
//  cdUIKit
//
//  Created by qbuser on 08/06/25.
//

import Foundation
class Item : Codable{
    var title: String
    var isCompleted : Bool = false
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
