//
//  Category.swift
//  Todoey
//
//  Created by ANDY on 2/18/19.
//  Copyright © 2019 ANDY. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    
    let items = List<Item>()
}
