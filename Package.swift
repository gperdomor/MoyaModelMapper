//
//  Package.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "MoyaModelMapper",
    targets: [
        Target(name: "MoyaModelMapper"),
        Target(name: "RxMoyaModelMapper", dependencies: ["MoyaModelMapper"]),
        Target(name: "ReactiveMoyaModelMapper", dependencies: ["MoyaModelMapper"])
    ],
    dependencies: [
        .Package(url: "https://github.com/Moya/Moya", majorVersion: 8),
        .Package(url: "https://github.com/lyft/mapper", majorVersion: 6)
    ],
    exclude: [
        "Carthage",
        "Configs",
        "Demo",
        "scripts"
    ]
)
