//
//  Observable+ModelMapper.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Mapper
import MoyaModelMapper

public extension ObservableType where E == Response {

    /// Maps data received from the observable into an object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the object.
    /// - Returns: Observable of object or error, if the data can't be mapped
    public func map<T: Mappable>(to type: T.Type, fromKey keyPath: String? = nil) -> Observable<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<T> in
                return Observable.just(try response.map(to: type, fromKey: keyPath))
            }
            .observeOn(MainScheduler.instance)
    }

    /// Maps data received from the observable into an array of objects which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the object.
    /// - Returns: Observable of array or error, if the data can't be mapped
    public func map<T: Mappable>(to type: [T.Type], fromKey keyPath: String? = nil) -> Observable<[T]> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<[T]> in
                return Observable.just(try response.map(to: type, fromKey: keyPath))
            }
            .observeOn(MainScheduler.instance)
    }

    /// Maps data received from the observable into an object which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the object.
    /// - Returns: Observable of object or nil, if the data can't be mapped
    public func mapOptional<T: Mappable>(to type: T.Type, fromKey keyPath: String? = nil) -> Observable<T?> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<T?> in
                do {
                    let object: T = try response.map(to: type, fromKey: keyPath)
                    return Observable.just(object)
                } catch {
                    return Observable.just(nil)
                }
            }
            .observeOn(MainScheduler.instance)
    }

    /// Maps data received from the observable into an array of objects which implements the Mappable protocol.
    ///
    /// - Parameters:
    ///   - type: Type of the object which implements the Mappable protocol.
    ///   - keyPath: Key of the inner json. This json will be used to map the object.
    /// - Returns: Observable of array or nil, if the data can't be mapped
    public func mapOptional<T: Mappable>(to type: [T.Type], fromKey keyPath: String? = nil) -> Observable<[T]?> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<[T]?> in
                do {
                    let object: [T] = try response.map(to: type, fromKey: keyPath)
                    return Observable.just(object)
                } catch {
                    return Observable.just(nil)
                }
            }
            .observeOn(MainScheduler.instance)
    }
}
