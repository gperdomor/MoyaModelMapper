//
//  ReactiveMoyaModelMapperSpec.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/20/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Moya
import ReactiveMoya
import ReactiveSwift
@testable import ReactiveMoyaModelMapper

class ReactiveMoyaModelMapperSpec: QuickSpec {
    override func spec() {
        describe("ReactiveMoyaModelMapper") {
            var provider: ReactiveSwiftMoyaProvider<GitHub>!

            beforeEach {
                provider = ReactiveSwiftMoyaProvider<GitHub>(stubClosure: ReactiveSwiftMoyaProvider.immediatelyStub)
            }

            describe("Map to Object") {
                var repo: Repository?
                var error: MoyaError?

                beforeEach {
                    repo = nil
                    error = nil
                }

                it("Can map response to object") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false))
                            .map(to: Repository.self)
                            .start { event in
                                switch event {
                                case .value(let object):
                                    repo = object
                                case .completed:
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repo).toNot(beNil())
                    expect(repo?.identifier).to(equal(1))
                    expect(repo?.name).to(equal("sygnaler"))
                    expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo?.language).to(equal("Swift"))

                }

                it("Can map response to object from a key path") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                            .map(to: Repository.self, fromKey: "data")
                            .start { event in
                                switch event {
                                case .value(let object):
                                    repo = object
                                case .completed:
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repo).toNot(beNil())
                    expect(repo?.identifier).to(equal(1))
                    expect(repo?.name).to(equal("sygnaler"))
                    expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo?.language).to(equal("Swift"))
                }

                it("Can throws error if mapping fails") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                            .map(to: Repository.self, fromKey: "no-existing-key")
                            .start { event in
                                switch event {
                                case .value(let object):
                                    repo = object
                                case .failed(let e):
                                    error = e
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repo).to(beNil())
                    expect(error).toNot(beNil())
                    expect(error).to(beAnInstanceOf(MoyaError.self))
                }

                context("Optionals") {
                    it("Can map response to optional object") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false))
                                .mapOptional(to: Repository.self)
                                .start { event in
                                    switch event {
                                    case .value(let object):
                                        repo = object
                                    case .completed:
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repo).toNot(beNil())
                        expect(repo?.identifier).to(equal(1))
                        expect(repo?.name).to(equal("sygnaler"))
                        expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                        expect(repo?.language).to(equal("Swift"))

                    }

                    it("Can map response to optional object from a key path") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                                .mapOptional(to: Repository.self, fromKey: "data")
                                .start { event in
                                    switch event {
                                    case .value(let object):
                                        repo = object
                                    case .completed:
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repo).toNot(beNil())
                        expect(repo?.identifier).to(equal(1))
                        expect(repo?.name).to(equal("sygnaler"))
                        expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                        expect(repo?.language).to(equal("Swift"))
                    }

                    it("Can return nil if mapping fails") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                                .mapOptional(to: Repository.self, fromKey: "no-existing-key")
                                .start { event in
                                    switch event {
                                    case .value(let object):
                                        repo = object
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repo).to(beNil())
                    }
                }
            }

            describe("Map to Array") {
                var repos: [Repository]?
                var error: MoyaError?

                beforeEach {
                    repos = nil
                    error = nil
                }

                it("can mapped to array of objects") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repos(username: "gperdomor", keyPath: false))
                            .map(to: [Repository.self])
                            .start { event in
                                switch event {
                                case .value(let objects):
                                    repos = objects
                                case .completed:
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repos).toNot(beNil())
                    expect(repos?.count).to(equal(1))
                    expect(repos?[0].identifier).to(equal(1))
                    expect(repos?[0].name).to(equal("sygnaler"))
                    expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos?[0].language).to(equal("Swift"))
                }

                it("can mapped to array of objects from key path") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repos(username: "gperdomor", keyPath: true))
                            .map(to: [Repository.self], fromKey: "data")
                            .start { event in
                                switch event {
                                case .value(let objects):
                                    repos = objects
                                case .completed:
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repos).toNot(beNil())
                    expect(repos?.count).to(equal(1))
                    expect(repos?[0].identifier).to(equal(1))
                    expect(repos?[0].name).to(equal("sygnaler"))
                    expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos?[0].language).to(equal("Swift"))
                }

                it("Can throws error if mapping fails") {
                    waitUntil { done in
                        provider
                            .request(GitHub.repos(username: "gperdomor", keyPath: true))
                            .map(to: [Repository.self], fromKey: "no-existing-key")
                            .start { event in
                                switch event {
                                case .value(let object):
                                    repos = object
                                case .failed(let e):
                                    error = e
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(repos).to(beNil())
                    expect(error).toNot(beNil())
                    expect(error).to(beAnInstanceOf(MoyaError.self))
                }

                context("Optionals") {
                    it("can mapped to array of objects") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repos(username: "gperdomor", keyPath: false))
                                .mapOptional(to: [Repository.self])
                                .start { event in
                                    switch event {
                                    case .value(let objects):
                                        repos = objects
                                    case .completed:
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repos).toNot(beNil())
                        expect(repos?.count).to(equal(1))
                        expect(repos?[0].identifier).to(equal(1))
                        expect(repos?[0].name).to(equal("sygnaler"))
                        expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                        expect(repos?[0].language).to(equal("Swift"))
                    }

                    it("can mapped to array of objects from key path") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repos(username: "gperdomor", keyPath: true))
                                .mapOptional(to: [Repository.self], fromKey: "data")
                                .start { event in
                                    switch event {
                                    case .value(let objects):
                                        repos = objects
                                    case .completed:
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repos).toNot(beNil())
                        expect(repos?.count).to(equal(1))
                        expect(repos?[0].identifier).to(equal(1))
                        expect(repos?[0].name).to(equal("sygnaler"))
                        expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                        expect(repos?[0].language).to(equal("Swift"))
                    }

                    it("Can return nil if mapping fails") {
                        waitUntil { done in
                            provider
                                .request(GitHub.repos(username: "gperdomor", keyPath: true))
                                .mapOptional(to: [Repository.self], fromKey: "no-existing-key")
                                .start { event in
                                    switch event {
                                    case .value(let object):
                                        repos = object
                                        done()
                                    default: break
                                    }
                            }
                        }

                        expect(repos).to(beNil())
                    }
                }
            }
        }
    }
}
