//
//  GithubEndpoint.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Foundation
import Moya
import Alamofire

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

enum GitHub {
    case repos(username: String, keyPath: Bool)
    case repo(fullName: String, keyPath: Bool)
}

extension GitHub: TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }

    var path: String {
        switch self {
        case .repos(let name, _):
            return "/users/\(name.URLEscapedString)/repos"
        case .repo(let name, _):
            return "/repos/\(name)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        return nil
    }

    var sampleData: Data {
        switch self {
        case .repos(let name, let keyPath):
            var response: String = "{}"

            if name == "gperdomor" {
                response = "[{\"id\": 1, \"name\": \"sygnaler\", \"full_name\": \"gperdomor/sygnaler\", \"language\": \"Swift\"}]"
            }

            if keyPath {
                response = "{\"data\": \(response)}"
            }

            return response.data(using: .utf8)!

        case .repo(let name, let keyPath):
            var response: String = "{}"

            if name == "gperdomor/sygnaler" {
                response = "{\"id\": 1, \"name\": \"sygnaler\", \"full_name\": \"gperdomor/sygnaler\", \"language\": \"Swift\"}"
            }

            if keyPath {
                response = "{\"data\": \(response)}"
            }

            return response.data(using: .utf8)!
        }
    }

    var task: Task {
        return .request
    }

    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
