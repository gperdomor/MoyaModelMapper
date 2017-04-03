//
//  Repository.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/20/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Foundation
import Mapper

class Repository: Mappable {
    let identifier: Int
    let language: String?
    let name: String
    let fullName: String

    required init(map: Mapper) throws {
        try identifier = map.from("id")
        try name = map.from("name")
        try fullName = map.from("full_name")
        language = map.optionalFrom("language")
    }
}
