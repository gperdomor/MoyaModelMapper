//
//  Issue.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/20/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Foundation
import Mapper

class Issue: Mappable {
    let identifier: Int
    let number: Int
    let title: String
    let body: String

    required init(map: Mapper) throws {
        try identifier = map.from("id")
        try number = map.from("number")
        try title = map.from("title")
        try body = map.from("body")
    }
}
