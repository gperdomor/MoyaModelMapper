//
//  Observable+ModelMapper.swift
//  MoyaModelMapper
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright (c) 2017 Gustavo Perdomo. Licensed under the MIT license, as follows:
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
