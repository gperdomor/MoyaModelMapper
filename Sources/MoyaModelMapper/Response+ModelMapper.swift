//
//  Response+ModelMapper.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Foundation
import Moya
import Mapper

public extension Response {

    /// Maps data received from the server into an object which implements the Mappable protocol.
    ///
    /// - Parameter type: Type of the object which implements the Mappable protocol.
    /// - Returns: The mappable object instance.
    /// - Throws: MoyaError if the response can't be mapped.
    public func map<T: Mappable>(to type: T.Type) throws -> T {
        guard let jsonDictionary = try mapJSON() as? NSDictionary,
            let object = T.from(jsonDictionary) else {
                throw MoyaError.jsonMapping(self)
        }

        return object
    }

    /// Maps data received from the server into an object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the object.
    /// - Returns: The mappable object instance.
    /// - Throws: MoyaError if the response can't be mapped.
    public func map<T: Mappable>(to type: T.Type, fromKey keyPath: String?) throws -> T {
        guard let keyPath = keyPath else { return try map(to: type) }

        guard let jsonDictionary = try mapJSON() as? NSDictionary,
            let objectDictionary = jsonDictionary.value(forKeyPath: keyPath) as? NSDictionary,
            let object = T.from(objectDictionary) else {
                throw MoyaError.jsonMapping(self)
        }

        return object
    }

    /// Maps data received from the server into an array of objects which implements the Mappable protocol.
    ///
    /// - Parameter type: Type of the object which implements the Mappable protocol.
    /// - Returns: The mappable object instance.
    /// - Throws: MoyaError if the response can't be mapped.
    public func map<T: Mappable>(to type: [T.Type]) throws -> [T] {
        guard let data = try mapJSON() as? NSArray,
            let object = T.from(data) else {
                throw MoyaError.jsonMapping(self)
        }
        return object

    }

    /// Maps data received from the server into an array of object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the array of object.
    /// - Returns: The mappable object instance.
    /// - Throws: MoyaError if the response can't be mapped.
    public func map<T: Mappable>(to type: [T.Type], fromKey keyPath: String? = nil) throws -> [T] {
        guard let keyPath = keyPath else { return try map(to: type) }

        guard let data = try mapJSON() as? NSDictionary,
            let objectArray = data.value(forKeyPath: keyPath) as? NSArray,
            let object = T.from(objectArray) else {
                throw MoyaError.jsonMapping(self)
        }

        return object
    }
}
