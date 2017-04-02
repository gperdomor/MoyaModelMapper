//
//  RxMoyaModelMapperSpec.swift
//  SwifterCode
//
//  Created by Gustavo Perdomo on 2/19/17.
//  Copyright © 2017 SwifterCode. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Moya
import RxMoya
import RxBlocking
import RxSwift
@testable import RxMoyaModelMapper

class RxMoyaModelMapperSpec: QuickSpec {
    override func spec() {
        describe("RxMoyaModelMapper") {
            var provider: RxMoyaProvider<GitHub>!

            beforeEach {
                provider = RxMoyaProvider<GitHub>(stubClosure: RxMoyaProvider.immediatelyStub)
            }

            describe("Map to Object") {
                var repo: Repository?
                var error: MoyaError?

                beforeEach {
                    repo = nil
                    error = nil
                }

                it("Can map response to object") {
                    do {
                        repo = try provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false))
                            .map(to: Repository.self)
                            .toBlocking()
                            .single()
                    } catch {}

                    expect(repo).toNot(beNil())
                    expect(repo?.identifier).to(equal(1))
                    expect(repo?.name).to(equal("sygnaler"))
                    expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo?.language).to(equal("Swift"))
                }

                it("Can map response to object from a key path") {
                    do {
                        repo = try provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                            .map(to: Repository.self, fromKey: "data")
                            .toBlocking()
                            .single()
                    } catch {}

                    expect(repo).toNot(beNil())
                    expect(repo?.identifier).to(equal(1))
                    expect(repo?.name).to(equal("sygnaler"))
                    expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                    expect(repo?.language).to(equal("Swift"))
                }

                it("Can throws error if mapping fails") {
                    waitUntil { done in
                        provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                            .map(to: Repository.self, fromKey: "no-existing-key")
                            .subscribe { event in
                                switch event {
                                case .error(let e):
                                    error = e as? MoyaError
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(error).toNot(beNil())
                    expect(error).to(beAnInstanceOf(MoyaError.self))
                }

                context("Optionals") {
                    it("Can map response to optional object") {
                        do {
                            repo = try provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: false))
                                .mapOptional(to: Repository.self)
                                .toBlocking()
                                .single()!
                        } catch {}

                        expect(repo).toNot(beNil())
                        expect(repo?.identifier).to(equal(1))
                        expect(repo?.name).to(equal("sygnaler"))
                        expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                        expect(repo?.language).to(equal("Swift"))
                    }

                    it("Can map response to optional object from a key path") {
                        do {
                            repo = try provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                                .mapOptional(to: Repository.self, fromKey: "data")
                                .toBlocking()
                                .single()!
                        } catch {}

                        expect(repo).toNot(beNil())
                        expect(repo?.identifier).to(equal(1))
                        expect(repo?.name).to(equal("sygnaler"))
                        expect(repo?.fullName).to(equal("gperdomor/sygnaler"))
                        expect(repo?.language).to(equal("Swift"))
                    }

                    it("Can return nil if mapping fails") {
                        waitUntil { done in
                            provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                                .mapOptional(to: Repository.self, fromKey: "no-existing-key")
                                .subscribe { event in
                                    switch event {
                                    case .next(let object):
                                        repo = object
                                    case .error(let e):
                                        error = e as? MoyaError
                                    default:
                                        done()
                                    }
                            }
                        }

                        expect(repo).to(beNil())
                        expect(error).to(beNil())
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
                    do {
                        repos = try provider.request(GitHub.repos(username: "gperdomor", keyPath: false))
                            .map(to: [Repository.self])
                            .toBlocking()
                            .single()
                    } catch {}

                    expect(repos).toNot(beNil())
                    expect(repos?.count).to(equal(1))
                    expect(repos?[0].identifier).to(equal(1))
                    expect(repos?[0].name).to(equal("sygnaler"))
                    expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos?[0].language).to(equal("Swift"))
                }

                it("can mapped to array of objects from key path") {
                    do {
                        repos = try provider.request(GitHub.repos(username: "gperdomor", keyPath: true))
                            .map(to: [Repository.self], fromKey: "data")
                            .toBlocking()
                            .single()
                    } catch {}

                    expect(repos).toNot(beNil())
                    expect(repos?.count).to(equal(1))
                    expect(repos?[0].identifier).to(equal(1))
                    expect(repos?[0].name).to(equal("sygnaler"))
                    expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                    expect(repos?[0].language).to(equal("Swift"))
                }

                it("Can throws error if mapping fails") {
                    waitUntil { done in
                        provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                            .map(to: [Repository.self], fromKey: "no-existing-key")
                            .subscribe { event in
                                switch event {
                                case .error(let e):
                                    error = e as? MoyaError
                                    done()
                                default: break
                                }
                        }
                    }

                    expect(error).toNot(beNil())
                    expect(error).to(beAnInstanceOf(MoyaError.self))
                }

                context("Optionals") {
                    it("can mapped to array of objects") {
                        do {
                            repos = try provider.request(GitHub.repos(username: "gperdomor", keyPath: false))
                                .mapOptional(to: [Repository.self])
                                .toBlocking()
                                .single()!
                        } catch {}

                        expect(repos).toNot(beNil())
                        expect(repos?.count).to(equal(1))
                        expect(repos?[0].identifier).to(equal(1))
                        expect(repos?[0].name).to(equal("sygnaler"))
                        expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                        expect(repos?[0].language).to(equal("Swift"))
                    }

                    it("can mapped to array of objects from key path") {
                        do {
                            repos = try provider.request(GitHub.repos(username: "gperdomor", keyPath: true))
                                .mapOptional(to: [Repository.self], fromKey: "data")
                                .toBlocking()
                                .single()!
                        } catch {}

                        expect(repos).toNot(beNil())
                        expect(repos?.count).to(equal(1))
                        expect(repos?[0].identifier).to(equal(1))
                        expect(repos?[0].name).to(equal("sygnaler"))
                        expect(repos?[0].fullName).to(equal("gperdomor/sygnaler"))
                        expect(repos?[0].language).to(equal("Swift"))
                    }

                    it("Can throws error if mapping fails") {
                        waitUntil { done in
                            provider.request(GitHub.repo(fullName: "gperdomor/sygnaler", keyPath: true))
                                .mapOptional(to: [Repository.self], fromKey: "no-existing-key")
                                .subscribe { event in
                                    switch event {
                                    case .next(let objects):
                                        repos = objects
                                    case .error(let e):
                                        error = e as? MoyaError
                                    default:
                                        done()
                                    }
                            }
                        }

                        expect(repos).to(beNil())
                        expect(error).to(beNil())
                    }
                }
            }
        }
    }
}
