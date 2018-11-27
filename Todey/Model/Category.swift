//
//  Category.swift
//  Todey
//
//  Created by Avilash on 28/10/18.
//  Copyright © 2018 Avilash. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
