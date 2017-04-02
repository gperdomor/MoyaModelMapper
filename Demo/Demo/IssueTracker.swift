//
//  IssueTracker.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/20/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Foundation
import Moya

class IssueTracker {
    let provider = MoyaProvider<GitHub>()

    func findUserRepositories(name: String, completion: @escaping Moya.Completion) -> Cancellable {
        return self.provider.request(GitHub.repos(username: name), completion: completion)
    }
}
