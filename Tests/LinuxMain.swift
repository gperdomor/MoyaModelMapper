//
//  LinuxMain.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import XCTest
import Quick
@testable import MoyaModelMapperTests
@testable import ReactiveMoyaModelMapperTests
@testable import RxMoyaModelMapperTests

Quick.QCKMain([
    MoyaModelMapperSpec.self,
    ReactiveMoyaModelMapperSpec.self,
    RxMoyaModelMapperSpec.self
])
