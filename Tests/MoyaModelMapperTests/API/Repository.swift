//
//  Repository.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Mapper

struct Repository: Mappable {
    let identifier: Int
    let name: String
    let fullName: String
    let language: String? // Optional property

    init(map: Mapper) throws {
        try identifier = map.from("id")
        try name = map.from("name")
        try fullName = map.from("full_name")
        language = map.optionalFrom("language") // Optional property
    }
}
