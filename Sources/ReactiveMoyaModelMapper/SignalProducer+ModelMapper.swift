//
//  SignalProducer+ModelMapper.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Moya
import Mapper
import ReactiveSwift
import MoyaModelMapper

extension SignalProducerProtocol where Value == Moya.Response, Error == MoyaError {

    /// Maps data received from the signal into an object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the object.
    /// - Returns: Signal with the object as value or error if the data can't be mapped.
    public func map<T: Mappable>(to type: T.Type, fromKey keyPath: String? = nil) -> SignalProducer<T, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<T, Error> in
            return unwrapThrowable { try response.map(to: type, fromKey: keyPath) }
        }
    }

    /// Maps data received from the signal into an array of objects which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the array of objects.
    /// - Returns: Signal with the array as value or error if the data can't be mapped.
    public func map<T: Mappable>(to type: [T.Type], fromKey keyPath: String? = nil) -> SignalProducer<[T], MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<[T], Error> in
            return unwrapThrowable { try response.map(to: type, fromKey: keyPath) }
        }
    }

    /// Maps data received from the signal into an object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the object.
    /// - Returns: Signal with the object or nil, as value.
    public func mapOptional<T: Mappable>(to type: T.Type, fromKey keyPath: String? = nil) -> SignalProducer<T?, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<T?, Error> in
            return unwrapOptionalThrowable { try response.map(to: type, fromKey: keyPath) }
        }
    }

    /// Maps data received from the signal into an array of objects which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the array of objects.
    /// - Returns: Signal with the array or nil as value.
    public func mapOptional<T: Mappable>(to type: [T.Type], fromKey keyPath: String? = nil) -> SignalProducer<[T]?, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<[T]?, Error> in
            return unwrapOptionalThrowable { try response.map(to: type, fromKey: keyPath) }
        }
    }
}

/// Maps throwable to SignalProducer
///
/// - Parameter throwable: Throwable closure
/// - Returns: SignalProducer
private func unwrapThrowable<T>(throwable: () throws -> T) -> SignalProducer<T, MoyaError> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(error: error as! MoyaError)
    }
}

/// Maps throwable to SignalProducer
///
/// - Parameter throwable: Throwable closure
/// - Returns: SignalProducer
private func unwrapOptionalThrowable<T>(throwable: () throws -> T) -> SignalProducer<T?, MoyaError> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        return SignalProducer(value: nil)
    }
}
